import 'package:dev_garden/application/services/content_block_service.dart';
import 'package:dev_garden/application/services/id_generator.dart';
import 'package:dev_garden/domain/models/entities.dart';
import 'package:dev_garden/domain/repositories/repositories.dart';
import 'package:dev_garden/infrastructure/database/app_database.dart';
import 'package:dev_garden/infrastructure/repositories/drift_repositories.dart';
import 'package:dev_garden/presentation/garden/content_block_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('opening an empty Idea creates an initial focused Paragraph', () async {
    final fixture = await _ControllerFixture.create();
    addTearDown(fixture.database.close);
    final controller = fixture.controller;
    addTearDown(controller.dispose);

    await controller.openIdea(fixture.idea.id);

    expect(controller.state.blocks, hasLength(1));
    expect(controller.state.blocks.single.type, ContentBlockType.paragraph);
    expect(controller.state.activeBlockId, controller.state.blocks.single.id);
    expect(controller.state.focusEpoch, greaterThan(0));
  });

  test(
    'editing, adding, reordering, and deleting blocks persist safely',
    () async {
      final fixture = await _ControllerFixture.create();
      addTearDown(fixture.database.close);
      final controller = fixture.controller;
      addTearDown(controller.dispose);
      await controller.openIdea(fixture.idea.id);
      final paragraph = controller.state.blocks.single;

      controller.updateText(paragraph.id, 'First draft');
      controller.updateText(paragraph.id, 'Final paragraph');
      await controller.flush();
      for (final type in ContentBlockType.values.skip(1)) {
        await controller.add(type, afterId: controller.state.blocks.last.id);
      }
      final code = controller.state.blocks.firstWhere(
        (block) => block.type == ContentBlockType.code,
      );
      controller.updateText(code.id, '  code\n\tkeeps whitespace\n');
      controller.updateMetadata(code.id, const {'language': 'python'});
      await controller.flush();
      await controller.move(code.id, -1);
      final checklist = controller.state.blocks.firstWhere(
        (block) => block.type == ContentBlockType.checklist,
      );
      await controller.toggleChecklist(checklist.id, true);
      final divider = controller.state.blocks.firstWhere(
        (block) => block.type == ContentBlockType.divider,
      );
      await controller.delete(divider.id);

      final restored = await fixture.blocks.listActiveByIdea(fixture.idea.id);
      expect(restored.first.text, 'Final paragraph');
      expect(
        restored.firstWhere((block) => block.id == code.id).text,
        '  code\n\tkeeps whitespace\n',
      );
      expect(
        restored.firstWhere((block) => block.id == code.id).codeLanguage,
        'python',
      );
      expect(
        restored.firstWhere((block) => block.id == checklist.id).isChecked,
        isTrue,
      );
      expect(restored.any((block) => block.id == divider.id), isFalse);
      expect(
        restored.map((block) => block.sortOrder),
        List.generate(restored.length, (index) => index),
      );
    },
  );

  test('slash commands and code fences convert Paragraph blocks', () async {
    final fixture = await _ControllerFixture.create();
    addTearDown(fixture.database.close);
    final controller = fixture.controller;
    addTearDown(controller.dispose);
    await controller.openIdea(fixture.idea.id);
    final first = controller.state.blocks.single;

    controller.updateText(first.id, '/heading');
    await controller.flush();
    await Future<void>.delayed(Duration.zero);
    expect(controller.state.blocks.single.type, ContentBlockType.heading);

    final paragraph = await controller.add(ContentBlockType.paragraph);
    controller.updateText(paragraph.id, '```python');
    await controller.flush();
    await Future<void>.delayed(Duration.zero);
    final converted = controller.state.blocks.firstWhere(
      (block) => block.id == paragraph.id,
    );
    expect(converted.type, ContentBlockType.code);
    expect(converted.codeLanguage, 'python');
    expect(converted.text, isEmpty);
  });

  test('command parser supports all requested block and language aliases', () {
    const blockCommands = [
      '/paragraph',
      '/heading',
      '/code',
      '/checklist',
      '/bullets',
      '/numbered',
      '/quote',
      '/divider',
    ];
    const languageCommands = [
      '/csharp',
      '/python',
      '/js',
      '/javascript',
      '/typescript',
      '/sql',
      '/json',
      '/html',
      '/css',
      '/dart',
    ];

    expect(
      blockCommands.every((command) => parseBlockInputCommand(command) != null),
      isTrue,
    );
    expect(
      languageCommands.every(
        (command) =>
            parseBlockInputCommand(command)?.type == ContentBlockType.code,
      ),
      isTrue,
    );
    expect(parseBlockInputCommand('```'), isNotNull);
    expect(parseBlockInputCommand('```csharp')?.metadata['language'], 'csharp');
    expect(parseBlockInputCommand('ordinary text'), isNull);
  });

  test(
    'continued typing during command recognition is never discarded',
    () async {
      final fixture = await _ControllerFixture.create();
      addTearDown(fixture.database.close);
      final controller = fixture.controller;
      addTearDown(controller.dispose);
      await controller.openIdea(fixture.idea.id);
      final block = controller.state.blocks.single;

      controller.updateText(block.id, '/code');
      controller.updateText(block.id, '/code followed by text');
      await controller.flush();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.blocks.single.type, ContentBlockType.paragraph);
      expect(controller.state.blocks.single.text, '/code followed by text');
    },
  );

  test('failed block save retains dirty text for retry', () async {
    const ideaId = EntityId('idea');
    final now = DateTime.utc(2026, 8, 8);
    final repository = _FailingBlockRepository();
    final controller = ContentBlockController(
      ContentBlockService(
        repository,
        _AvailableIdeaRepository(ideaId, now),
        const UuidV7IdGenerator(),
        () => now,
      ),
    );
    addTearDown(controller.dispose);
    await controller.openIdea(ideaId);
    final id = controller.state.blocks.single.id;

    controller.updateText(id, 'Unsaved block text');
    await controller.flush();

    expect(controller.state.saveState, BlockSaveState.failed);
    expect(controller.state.dirtyIds, contains(id));
    expect(controller.state.blocks.single.text, 'Unsaved block text');
    expect(
      controller.state.errorMessage,
      'Your block changes could not be saved. They remain in the editor.',
    );
  });
}

class _ControllerFixture {
  _ControllerFixture(this.database, this.idea, this.blocks, this.controller);

  final AppDatabase database;
  final Idea idea;
  final DriftContentBlockRepository blocks;
  final ContentBlockController controller;

  static Future<_ControllerFixture> create() async {
    final database = AppDatabase(NativeDatabase.memory());
    final now = DateTime.utc(2026, 8, 8);
    final workspaces = DriftWorkspaceRepository(database);
    final projects = DriftProjectRepository(database);
    final apps = DriftAppRepository(database);
    final ideas = DriftIdeaRepository(database);
    await workspaces.create(
      Workspace(
        id: const EntityId('workspace'),
        name: 'Workspace',
        createdAt: now,
        updatedAt: now,
        sortOrder: 0,
        isDeleted: false,
      ),
    );
    await projects.create(
      Project(
        id: const EntityId('project'),
        workspaceId: const EntityId('workspace'),
        name: 'Project',
        createdAt: now,
        updatedAt: now,
        sortOrder: 0,
        isDeleted: false,
      ),
    );
    await apps.create(
      GardenApp(
        id: const EntityId('app'),
        projectId: const EntityId('project'),
        name: 'App',
        createdAt: now,
        updatedAt: now,
        sortOrder: 0,
        isDeleted: false,
      ),
    );
    final idea = await ideas.create(
      Idea(
        id: const EntityId('idea'),
        appId: const EntityId('app'),
        title: 'Idea',
        body: '',
        lifecycle: IdeaLifecycle.idea,
        createdAt: now,
        updatedAt: now,
        sortOrder: 0,
        isPinned: false,
        isDeleted: false,
      ),
    );
    final blocks = DriftContentBlockRepository(database);
    final controller = ContentBlockController(
      ContentBlockService(blocks, ideas, const UuidV7IdGenerator(), () => now),
    );
    return _ControllerFixture(database, idea, blocks, controller);
  }
}

class _FailingBlockRepository implements ContentBlockRepository {
  ContentBlock? block;

  @override
  Future<ContentBlock> create(ContentBlock value) async {
    block = value;
    return value;
  }

  @override
  Future<ContentBlock?> getById(EntityId id) async => block;

  @override
  Future<List<ContentBlock>> listActiveByIdea(EntityId ideaId) async => [
    ?block,
  ];

  @override
  Future<void> reorder({
    required EntityId ideaId,
    required List<EntityId> orderedIds,
    required DateTime updatedAt,
  }) async {}

  @override
  Future<void> softDelete(EntityId id, DateTime updatedAt) async {}

  @override
  Future<ContentBlock> update({
    required EntityId id,
    required ContentBlockType type,
    required String text,
    required Map<String, Object?> metadata,
    required DateTime updatedAt,
  }) {
    throw const FileSystemExceptionForTest();
  }
}

class _AvailableIdeaRepository implements IdeaRepository {
  _AvailableIdeaRepository(this.id, this.now);

  final EntityId id;
  final DateTime now;

  Idea get idea => Idea(
    id: id,
    appId: const EntityId('app'),
    title: 'Idea',
    body: '',
    lifecycle: IdeaLifecycle.idea,
    createdAt: now,
    updatedAt: now,
    sortOrder: 0,
    isPinned: false,
    isDeleted: false,
  );

  @override
  Future<Idea?> getById(EntityId id) async => idea;

  @override
  Future<Idea> create(Idea idea) async => idea;

  @override
  Future<Idea> assignToGroup({
    required EntityId id,
    required EntityId? groupId,
    required DateTime updatedAt,
  }) async => idea;

  @override
  Future<List<Idea>> listActiveByApp(EntityId appId) async => [idea];

  @override
  Future<List<Idea>> listActiveByGroup(EntityId groupId) async => [idea];

  @override
  Future<List<Idea>> listActiveUngroupedByApp(EntityId appId) async => [idea];

  @override
  Future<List<Idea>> search(EntityId appId, String query) async => [idea];

  @override
  Future<void> softDelete(EntityId id, DateTime updatedAt) async {}

  @override
  Future<Idea> updateTitle({
    required EntityId id,
    required String title,
    required DateTime updatedAt,
  }) async => idea;
}

class FileSystemExceptionForTest implements Exception {
  const FileSystemExceptionForTest();
}
