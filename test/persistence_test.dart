import 'dart:io';

import 'package:dev_garden/application/services/content_block_service.dart';
import 'package:dev_garden/application/services/hierarchy_service.dart';
import 'package:dev_garden/application/services/id_generator.dart';
import 'package:dev_garden/application/services/idea_group_service.dart';
import 'package:dev_garden/application/services/idea_service.dart';
import 'package:dev_garden/domain/models/entities.dart';
import 'package:dev_garden/infrastructure/database/app_database.dart';
import 'package:dev_garden/infrastructure/repositories/drift_repositories.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  group('Content Block persistence', () {
    late AppDatabase database;
    late _Fixture fixture;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      fixture = _Fixture(database);
    });

    tearDown(() => database.close());

    test(
      'all initial block types persist ordered content and metadata',
      () async {
        final hierarchy = await fixture.createHierarchy();
        final idea = await fixture.ideaService.capture(hierarchy.app.id);
        final created = <ContentBlock>[
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.paragraph,
            sortOrder: 0,
            text: 'Paragraph text',
          ),
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.heading,
            sortOrder: 1,
            text: 'Heading text',
            metadata: const {'level': 2},
          ),
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.code,
            sortOrder: 2,
            text: '  first\n\tsecond\n',
            metadata: const {'language': 'python'},
          ),
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.checklist,
            sortOrder: 3,
            text: 'Checked item',
            metadata: const {'checked': true},
          ),
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.bulletList,
            sortOrder: 4,
            text: 'One\nTwo',
          ),
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.numberedList,
            sortOrder: 5,
            text: 'First\nSecond',
          ),
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.quote,
            sortOrder: 6,
            text: 'Quoted text',
          ),
          await fixture.blockService.create(
            idea.id,
            ContentBlockType.divider,
            sortOrder: 7,
          ),
        ];

        final restored = await fixture.blocks.listActiveByIdea(idea.id);

        expect(created.every((block) => block.id.value.contains('-7')), isTrue);
        expect(restored.map((block) => block.ideaId).toSet(), {idea.id});
        expect(restored.map((block) => block.type), ContentBlockType.values);
        expect(
          restored.map((block) => block.sortOrder),
          List.generate(8, (i) => i),
        );
        expect(restored[0].text, 'Paragraph text');
        expect(restored[1].headingLevel, 2);
        expect(restored[2].text, '  first\n\tsecond\n');
        expect(restored[2].codeLanguage, 'python');
        expect(restored[3].isChecked, isTrue);
        expect(restored[4].text, 'One\nTwo');
        expect(restored[5].text, 'First\nSecond');
        expect(restored[6].text, 'Quoted text');
        expect(restored[7].text, isEmpty);
        expect(restored.every((block) => block.payloadVersion == 1), isTrue);
      },
    );

    test('update preserves identity and reorder persists', () async {
      final hierarchy = await fixture.createHierarchy();
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      final first = await fixture.blockService.create(
        idea.id,
        ContentBlockType.paragraph,
        sortOrder: 0,
        text: 'First',
      );
      final second = await fixture.blockService.create(
        idea.id,
        ContentBlockType.code,
        sortOrder: 1,
        text: 'Second',
      );

      final updated = await fixture.blockService.update(first, text: 'Updated');
      await fixture.blockService.reorder(idea.id, [second.id, first.id]);
      final restored = await fixture.blocks.listActiveByIdea(idea.id);

      expect(updated.id, first.id);
      expect(updated.text, 'Updated');
      expect(restored.map((block) => block.id), [second.id, first.id]);
      expect(restored.map((block) => block.sortOrder), [0, 1]);
    });

    test('soft deletion hides one block and retains its siblings', () async {
      final hierarchy = await fixture.createHierarchy();
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      final first = await fixture.blockService.create(
        idea.id,
        ContentBlockType.paragraph,
        sortOrder: 0,
      );
      final second = await fixture.blockService.create(
        idea.id,
        ContentBlockType.quote,
        sortOrder: 1,
      );

      await fixture.blockService.softDelete(first.id);

      expect(
        (await fixture.blocks.listActiveByIdea(idea.id)).single.id,
        second.id,
      );
      expect((await fixture.blocks.getById(first.id))?.isDeleted, isTrue);
      expect((await fixture.ideas.getById(idea.id))?.isDeleted, isFalse);
    });

    test('search finds active textual blocks across Idea Groups', () async {
      final hierarchy = await fixture.createHierarchy();
      final group = await fixture.groupService.create(
        hierarchy.app.id,
        'Grouped',
      );
      final types = [
        ContentBlockType.paragraph,
        ContentBlockType.heading,
        ContentBlockType.code,
        ContentBlockType.checklist,
        ContentBlockType.bulletList,
        ContentBlockType.numberedList,
        ContentBlockType.quote,
      ];
      for (var index = 0; index < types.length; index++) {
        final idea = await fixture.ideaService.capture(hierarchy.app.id);
        if (index.isEven) await fixture.groupService.assign(idea.id, group.id);
        await fixture.blockService.create(
          idea.id,
          types[index],
          sortOrder: 0,
          text: 'unique-$index',
        );
      }

      for (var index = 0; index < types.length; index++) {
        final results = await fixture.ideaService.search(
          hierarchy.app.id,
          'unique-$index',
        );
        expect(results, hasLength(1));
      }
    });

    test('search ignores deleted blocks and deleted Ideas', () async {
      final hierarchy = await fixture.createHierarchy();
      final blockDeletedIdea = await fixture.ideaService.capture(
        hierarchy.app.id,
      );
      final deletedBlock = await fixture.blockService.create(
        blockDeletedIdea.id,
        ContentBlockType.code,
        sortOrder: 0,
        text: 'deleted-block-text',
      );
      await fixture.blockService.softDelete(deletedBlock.id);

      final deletedIdea = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.blockService.create(
        deletedIdea.id,
        ContentBlockType.paragraph,
        sortOrder: 0,
        text: 'deleted-idea-text',
      );
      await fixture.ideaService.softDelete(deletedIdea.id);

      expect(
        await fixture.ideaService.search(
          hierarchy.app.id,
          'deleted-block-text',
        ),
        isEmpty,
      );
      expect(
        await fixture.ideaService.search(hierarchy.app.id, 'deleted-idea-text'),
        isEmpty,
      );
    });

    test('moving and group archive preserve all Idea blocks', () async {
      final hierarchy = await fixture.createHierarchy();
      final group = await fixture.groupService.create(
        hierarchy.app.id,
        'Later',
      );
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      final block = await fixture.blockService.create(
        idea.id,
        ContentBlockType.code,
        sortOrder: 0,
        text: 'preserved code',
      );

      await fixture.groupService.assign(idea.id, group.id);
      expect(
        (await fixture.blocks.listActiveByIdea(idea.id)).single.id,
        block.id,
      );
      await fixture.groupService.archive(group.id);

      expect((await fixture.ideas.getById(idea.id))?.groupId, isNull);
      expect(
        (await fixture.blocks.listActiveByIdea(idea.id)).single.text,
        'preserved code',
      );
    });
  });

  test('schema v2 migrates legacy bodies and preserves Idea data', () async {
    final file = await _temporaryDatabase('v2');
    final raw = sqlite.sqlite3.open(file.path);
    _createSchemaV2(raw);
    raw.execute('''
      INSERT INTO idea_groups VALUES ('g', 'a', 'Group', 1, 1, 0, 0);
      INSERT INTO ideas (
        id, app_id, title, body, lifecycle, created_at, updated_at,
        sort_order, is_pinned, is_deleted, group_id
      ) VALUES (
        'grouped', 'a', 'Original title', 'This is my original idea.',
        'building', 10, 20, 3, 1, 0, 'g'
      );
      INSERT INTO ideas (
        id, app_id, title, body, lifecycle, created_at, updated_at,
        sort_order, is_pinned, is_deleted, group_id
      ) VALUES (
        'empty', 'a', 'Empty title', '', 'idea', 11, 21, 4, 0, 0, NULL
      );
      INSERT INTO ideas (
        id, app_id, title, body, lifecycle, created_at, updated_at,
        sort_order, is_pinned, is_deleted, group_id
      ) VALUES (
        'deleted', 'a', 'Deleted title', 'Deleted content',
        'rejected', 12, 22, 5, 0, 1, NULL
      );
      PRAGMA user_version = 2;
    ''');
    raw.close();

    final database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);
    final ideas = DriftIdeaRepository(database);
    final blocks = DriftContentBlockRepository(database);
    final grouped = await ideas.getById(const EntityId('grouped'));
    final deleted = await ideas.getById(const EntityId('deleted'));

    expect(await _schemaVersion(database), 3);
    expect(grouped?.id, const EntityId('grouped'));
    expect(grouped?.title, 'Original title');
    expect(grouped?.groupId, const EntityId('g'));
    expect(grouped?.lifecycle, IdeaLifecycle.building);
    expect(grouped?.isPinned, isTrue);
    expect(grouped?.createdAt.millisecondsSinceEpoch, 10000);
    expect(grouped?.updatedAt.millisecondsSinceEpoch, 20000);
    expect(grouped?.body, 'This is my original idea.');
    final migrated = await blocks.listActiveByIdea(const EntityId('grouped'));
    expect(migrated, hasLength(1));
    expect(migrated.single.id.value, matches(_uuidV7Pattern));
    expect(migrated.single.type, ContentBlockType.paragraph);
    expect(migrated.single.text, 'This is my original idea.');
    expect(await blocks.listActiveByIdea(const EntityId('empty')), isEmpty);
    expect(deleted?.isDeleted, isTrue);
    expect(deleted?.lifecycle, IdeaLifecycle.rejected);
    expect(
      (await blocks.listActiveByIdea(const EntityId('deleted'))).single.text,
      'Deleted content',
    );
  });

  test('schema v1 upgrades through v2 to v3 without data loss', () async {
    final file = await _temporaryDatabase('v1');
    final raw = sqlite.sqlite3.open(file.path);
    _createSchemaV1(raw);
    raw.execute('''
      INSERT INTO ideas VALUES (
        'i', 'a', 'Existing Idea', 'Existing body', 'approved', 1, 2, 0, 0, 0
      );
      PRAGMA user_version = 1;
    ''');
    raw.close();

    final database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);
    final idea = await DriftIdeaRepository(
      database,
    ).getById(const EntityId('i'));
    final block = (await DriftContentBlockRepository(
      database,
    ).listActiveByIdea(const EntityId('i'))).single;

    expect(await _schemaVersion(database), 3);
    expect(idea?.id, const EntityId('i'));
    expect(idea?.groupId, isNull);
    expect(idea?.title, 'Existing Idea');
    expect(idea?.lifecycle, IdeaLifecycle.approved);
    expect(block.text, 'Existing body');
    expect(block.type, ContentBlockType.paragraph);
  });

  test('blocks survive close and reopen from a temporary file', () async {
    final file = await _temporaryDatabase('restart');
    final firstDatabase = AppDatabase(NativeDatabase(file));
    final first = _Fixture(firstDatabase);
    final hierarchy = await first.createHierarchy();
    final idea = await first.ideaService.capture(hierarchy.app.id);
    final block = await first.blockService.create(
      idea.id,
      ContentBlockType.code,
      sortOrder: 0,
      text: 'line one\n  line two\n',
      metadata: const {'language': 'dart'},
    );
    await firstDatabase.close();

    final reopened = AppDatabase(NativeDatabase(file));
    addTearDown(reopened.close);
    final restored = await DriftContentBlockRepository(
      reopened,
    ).getById(block.id);

    expect(restored?.text, 'line one\n  line two\n');
    expect(restored?.codeLanguage, 'dart');
    expect(restored?.id, block.id);
  });
}

final _uuidV7Pattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

Future<File> _temporaryDatabase(String label) async {
  final directory = await Directory.systemTemp.createTemp(
    'dev_garden_${label}_test_',
  );
  addTearDown(() => directory.delete(recursive: true));
  return File('${directory.path}${Platform.pathSeparator}$label.sqlite');
}

Future<int> _schemaVersion(AppDatabase database) async {
  final row = await database.customSelect('PRAGMA user_version').getSingle();
  return row.read<int>('user_version');
}

void _createSchemaV1(sqlite.Database raw) {
  raw.execute('''
    CREATE TABLE workspaces (
      id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL,
      created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
    );
    CREATE TABLE projects (
      id TEXT NOT NULL PRIMARY KEY,
      workspace_id TEXT NOT NULL REFERENCES workspaces(id) ON DELETE RESTRICT,
      name TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
    );
    CREATE TABLE apps (
      id TEXT NOT NULL PRIMARY KEY,
      project_id TEXT NOT NULL REFERENCES projects(id) ON DELETE RESTRICT,
      name TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
    );
    CREATE TABLE ideas (
      id TEXT NOT NULL PRIMARY KEY,
      app_id TEXT NOT NULL REFERENCES apps(id) ON DELETE RESTRICT,
      title TEXT NOT NULL, body TEXT NOT NULL, lifecycle TEXT NOT NULL,
      created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      is_pinned INTEGER NOT NULL DEFAULT 0 CHECK (is_pinned IN (0, 1)),
      is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
    );
    INSERT INTO workspaces VALUES ('w', 'Workspace', 1, 1, 0, 0);
    INSERT INTO projects VALUES ('p', 'w', 'Project', 1, 1, 0, 0);
    INSERT INTO apps VALUES ('a', 'p', 'App', 1, 1, 0, 0);
  ''');
}

void _createSchemaV2(sqlite.Database raw) {
  _createSchemaV1(raw);
  raw.execute('''
    CREATE TABLE idea_groups (
      id TEXT NOT NULL PRIMARY KEY,
      app_id TEXT NOT NULL REFERENCES apps(id) ON DELETE RESTRICT,
      name TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
    );
    ALTER TABLE ideas ADD COLUMN group_id TEXT NULL
      REFERENCES idea_groups(id) ON DELETE SET NULL;
  ''');
}

class _Fixture {
  _Fixture(AppDatabase database)
    : workspaces = DriftWorkspaceRepository(database),
      projects = DriftProjectRepository(database),
      apps = DriftAppRepository(database),
      groups = DriftIdeaGroupRepository(database),
      ideas = DriftIdeaRepository(database),
      blocks = DriftContentBlockRepository(database) {
    hierarchyService = HierarchyService(
      workspaces,
      projects,
      apps,
      const UuidV7IdGenerator(),
      () => now,
    );
    ideaService = IdeaService(ideas, const UuidV7IdGenerator(), () => now);
    groupService = IdeaGroupService(
      groups,
      ideas,
      const UuidV7IdGenerator(),
      () => now,
    );
    blockService = ContentBlockService(
      blocks,
      ideas,
      const UuidV7IdGenerator(),
      () => now,
    );
  }

  DateTime now = DateTime.utc(2026, 8, 8, 12);
  final DriftWorkspaceRepository workspaces;
  final DriftProjectRepository projects;
  final DriftAppRepository apps;
  final DriftIdeaGroupRepository groups;
  final DriftIdeaRepository ideas;
  final DriftContentBlockRepository blocks;
  late final HierarchyService hierarchyService;
  late final IdeaService ideaService;
  late final IdeaGroupService groupService;
  late final ContentBlockService blockService;

  Future<_Hierarchy> createHierarchy() async {
    final workspace = await hierarchyService.createWorkspace('Workspace');
    final project = await hierarchyService.createProject(
      workspace.id,
      'Project',
    );
    final app = await hierarchyService.createApp(project.id, 'App');
    return _Hierarchy(workspace, project, app);
  }
}

class _Hierarchy {
  const _Hierarchy(this.workspace, this.project, this.app);

  final Workspace workspace;
  final Project project;
  final GardenApp app;
}
