import 'dart:io';

import 'package:dev_garden/application/services/hierarchy_service.dart';
import 'package:dev_garden/application/services/id_generator.dart';
import 'package:dev_garden/application/services/idea_service.dart';
import 'package:dev_garden/application/services/idea_group_service.dart';
import 'package:dev_garden/domain/models/entities.dart';
import 'package:dev_garden/infrastructure/database/app_database.dart';
import 'package:dev_garden/infrastructure/repositories/drift_repositories.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  group('Drift persistence slice', () {
    late AppDatabase database;
    late _Fixture fixture;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      fixture = _Fixture(database);
    });

    tearDown(() => database.close());

    test(
      'UUID v7 identity is assigned before persistence and preserved',
      () async {
        final hierarchy = await fixture.createHierarchy();
        final idea = await fixture.ideaService.capture(hierarchy.app.id);

        for (final id in [
          hierarchy.workspace.id,
          hierarchy.project.id,
          hierarchy.app.id,
          idea.id,
        ]) {
          expect(id.value, matches(_uuidV7Pattern));
        }
        expect((await fixture.ideas.getById(idea.id))?.id, idea.id);
      },
    );

    test('Workspace creation persists and lists active records', () async {
      final workspace = await fixture.hierarchyService.createWorkspace(
        'Garden',
      );

      final restored = await fixture.workspaces.listActive();

      expect(restored.single.id, workspace.id);
      expect(restored.single.name, 'Garden');
    });

    test('Project and App preserve their hierarchy relationships', () async {
      final hierarchy = await fixture.createHierarchy();

      final projects = await fixture.projects.listActiveByWorkspace(
        hierarchy.workspace.id,
      );
      final apps = await fixture.apps.listActiveByProject(hierarchy.project.id);

      expect(projects.single.workspaceId, hierarchy.workspace.id);
      expect(apps.single.projectId, hierarchy.project.id);
    });

    test('Idea belongs to App and title/body updates persist', () async {
      final hierarchy = await fixture.createHierarchy();
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      final originalUpdatedAt = idea.updatedAt;
      fixture.advanceClock();

      final updated = await fixture.ideaService.update(
        idea.id,
        'Renamed Idea',
        'Recognizable body text',
      );
      final restored = await fixture.ideas.getById(idea.id);

      expect(updated.appId, hierarchy.app.id);
      expect(restored?.title, 'Renamed Idea');
      expect(restored?.body, 'Recognizable body text');
      expect(restored?.updatedAt.isAfter(originalUpdatedAt), isTrue);
    });

    test('Idea Groups are optional and assignment is reversible', () async {
      final hierarchy = await fixture.createHierarchy();
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      final group = await fixture.groupService.create(
        hierarchy.app.id,
        'Research',
      );

      expect(idea.groupId, isNull);
      final grouped = await fixture.groupService.assign(idea.id, group.id);
      expect(grouped.groupId, group.id);
      expect(
        (await fixture.ideas.listActiveByGroup(group.id)).single.id,
        idea.id,
      );

      final ungrouped = await fixture.groupService.assign(idea.id, null);
      expect(ungrouped.groupId, isNull);
      expect(
        (await fixture.ideas.listActiveUngroupedByApp(
          hierarchy.app.id,
        )).single.id,
        idea.id,
      );
    });

    test('cross-App assignment is rejected', () async {
      final first = await fixture.createHierarchy();
      final secondProject = await fixture.hierarchyService.createProject(
        first.workspace.id,
        'Second Project',
      );
      final secondApp = await fixture.hierarchyService.createApp(
        secondProject.id,
        'Second App',
      );
      final idea = await fixture.ideaService.capture(first.app.id);
      final otherGroup = await fixture.groupService.create(
        secondApp.id,
        'Other',
      );

      await expectLater(
        fixture.groupService.assign(idea.id, otherGroup.id),
        throwsStateError,
      );
      expect((await fixture.ideas.getById(idea.id))?.groupId, isNull);
    });

    test('archiving a group retains and ungroups its active Ideas', () async {
      final hierarchy = await fixture.createHierarchy();
      final group = await fixture.groupService.create(
        hierarchy.app.id,
        'Later',
      );
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.groupService.assign(idea.id, group.id);

      await fixture.groupService.archive(group.id);

      expect(await fixture.groups.listActiveByApp(hierarchy.app.id), isEmpty);
      final retained = await fixture.ideas.getById(idea.id);
      expect(retained, isNotNull);
      expect(retained!.isDeleted, isFalse);
      expect(retained.groupId, isNull);
    });

    test('search finds title and body matches', () async {
      final hierarchy = await fixture.createHierarchy();
      final first = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.ideaService.update(
        first.id,
        'Compiler garden',
        'plain body',
      );
      final second = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.ideaService.update(
        second.id,
        'Other title',
        'riverpod notes',
      );

      final titleMatches = await fixture.ideaService.search(
        hierarchy.app.id,
        'compiler',
      );
      final bodyMatches = await fixture.ideaService.search(
        hierarchy.app.id,
        'riverpod',
      );

      expect(titleMatches.map((idea) => idea.id), contains(first.id));
      expect(bodyMatches.map((idea) => idea.id), contains(second.id));
    });

    test('soft deletion excludes Ideas from active lists and search', () async {
      final hierarchy = await fixture.createHierarchy();
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.ideaService.update(idea.id, 'Archive target', 'searchable');

      await fixture.ideaService.softDelete(idea.id);

      expect(await fixture.ideas.listActiveByApp(hierarchy.app.id), isEmpty);
      expect(
        await fixture.ideaService.search(hierarchy.app.id, 'searchable'),
        isEmpty,
      );
      final retained = await fixture.ideas.getById(idea.id);
      expect(retained, isNotNull);
      expect(retained!.isDeleted, isTrue);
    });
  });

  test('database survives close and reopen from a temporary file', () async {
    final directory = await Directory.systemTemp.createTemp(
      'dev_garden_database_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}${Platform.pathSeparator}slice.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final firstFixture = _Fixture(firstDatabase);
    final hierarchy = await firstFixture.createHierarchy();
    final idea = await firstFixture.ideaService.capture(hierarchy.app.id);
    await firstFixture.ideaService.update(
      idea.id,
      'Persistent title',
      'Persistent body',
    );
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final reopenedIdeas = DriftIdeaRepository(reopenedDatabase);
    final restored = await reopenedIdeas.getById(idea.id);

    expect(restored?.title, 'Persistent title');
    expect(restored?.body, 'Persistent body');
    expect(restored?.id, idea.id);
  });

  test('schema v1 migrates to v2 without changing existing Ideas', () async {
    final directory = await Directory.systemTemp.createTemp(
      'dev_garden_migration_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}${Platform.pathSeparator}v1.sqlite');
    final raw = sqlite.sqlite3.open(file.path);
    raw.execute('''
      CREATE TABLE workspaces (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
      );
      CREATE TABLE projects (
        id TEXT NOT NULL PRIMARY KEY,
        workspace_id TEXT NOT NULL REFERENCES workspaces(id) ON DELETE RESTRICT,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
      );
      CREATE TABLE apps (
        id TEXT NOT NULL PRIMARY KEY,
        project_id TEXT NOT NULL REFERENCES projects(id) ON DELETE RESTRICT,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
      );
      CREATE TABLE ideas (
        id TEXT NOT NULL PRIMARY KEY,
        app_id TEXT NOT NULL REFERENCES apps(id) ON DELETE RESTRICT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        lifecycle TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        is_pinned INTEGER NOT NULL DEFAULT 0 CHECK (is_pinned IN (0, 1)),
        is_deleted INTEGER NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1))
      );
      INSERT INTO workspaces VALUES ('w', 'Workspace', 1, 1, 0, 0);
      INSERT INTO projects VALUES ('p', 'w', 'Project', 1, 1, 0, 0);
      INSERT INTO apps VALUES ('a', 'p', 'App', 1, 1, 0, 0);
      INSERT INTO ideas VALUES (
        'i', 'a', 'Existing Idea', 'Existing body', 'idea', 1, 1, 0, 0, 0
      );
      PRAGMA user_version = 1;
    ''');
    raw.close();

    final migrated = AppDatabase(NativeDatabase(file));
    addTearDown(migrated.close);
    final restored = await DriftIdeaRepository(
      migrated,
    ).getById(const EntityId('i'));
    final version = await migrated
        .customSelect('PRAGMA user_version')
        .getSingle();

    expect(version.data['user_version'], 2);
    expect(restored?.title, 'Existing Idea');
    expect(restored?.body, 'Existing body');
    expect(restored?.groupId, isNull);
    expect(
      await DriftIdeaGroupRepository(
        migrated,
      ).listActiveByApp(const EntityId('a')),
      isEmpty,
    );
  });
}

final _uuidV7Pattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

class _Fixture {
  _Fixture(AppDatabase database)
    : workspaces = DriftWorkspaceRepository(database),
      projects = DriftProjectRepository(database),
      apps = DriftAppRepository(database),
      ideas = DriftIdeaRepository(database) {
    groups = DriftIdeaGroupRepository(database);
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
  }

  DateTime now = DateTime.utc(2026, 8, 7, 12);
  final DriftWorkspaceRepository workspaces;
  final DriftProjectRepository projects;
  final DriftAppRepository apps;
  final DriftIdeaRepository ideas;
  late final DriftIdeaGroupRepository groups;
  late final HierarchyService hierarchyService;
  late final IdeaService ideaService;
  late final IdeaGroupService groupService;

  void advanceClock() {
    now = now.add(const Duration(minutes: 1));
  }

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
