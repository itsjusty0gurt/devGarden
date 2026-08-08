import 'package:dev_garden/application/services/id_generator.dart';
import 'package:dev_garden/application/services/idea_service.dart';
import 'package:dev_garden/application/services/idea_group_service.dart';
import 'package:dev_garden/domain/models/entities.dart';
import 'package:dev_garden/domain/repositories/repositories.dart';
import 'package:dev_garden/presentation/garden/idea_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('failed save keeps unsaved editor text available for retry', () async {
    final repository = _FailingUpdateRepository();
    final now = DateTime.utc(2026, 8, 7);
    final service = IdeaService(
      repository,
      const UuidV7IdGenerator(),
      () => now,
    );
    final controller = IdeaController(
      service,
      IdeaGroupService(
        _FakeIdeaGroupRepository(),
        repository,
        const UuidV7IdGenerator(),
        () => now,
      ),
      repository,
    );
    addTearDown(controller.dispose);
    const appId = EntityId('app-id');

    await controller.selectApp(appId);
    await controller.capture();
    controller.updateDraftTitle('Unsaved title');
    await controller.flush();

    expect(controller.state.saveState, IdeaSaveState.failed);
    expect(controller.state.isDirty, isTrue);
    expect(controller.state.draftTitle, 'Unsaved title');
    expect(
      controller.state.errorMessage,
      'Your changes could not be saved. They remain in the editor.',
    );
  });
}

class _FailingUpdateRepository implements IdeaRepository {
  Idea? idea;

  @override
  Future<Idea> create(Idea value) async {
    idea = value;
    return value;
  }

  @override
  Future<Idea?> getById(EntityId id) async => idea;

  @override
  Future<List<Idea>> listActiveByApp(EntityId appId) async => [?idea];

  @override
  Future<List<Idea>> listActiveUngroupedByApp(EntityId appId) async => [?idea];

  @override
  Future<List<Idea>> listActiveByGroup(EntityId groupId) async => [];

  @override
  Future<Idea> assignToGroup({
    required EntityId id,
    required EntityId? groupId,
    required DateTime updatedAt,
  }) async => idea!.copyWith(groupId: groupId, clearGroup: groupId == null);

  @override
  Future<List<Idea>> search(EntityId appId, String query) =>
      listActiveByApp(appId);

  @override
  Future<void> softDelete(EntityId id, DateTime updatedAt) async {}

  @override
  Future<Idea> updateTitle({
    required EntityId id,
    required String title,
    required DateTime updatedAt,
  }) {
    throw const FileSystemExceptionForTest();
  }
}

class _FakeIdeaGroupRepository implements IdeaGroupRepository {
  @override
  Future<void> archiveAndUngroup(EntityId id, DateTime updatedAt) async {}

  @override
  Future<IdeaGroup> create(IdeaGroup group) async => group;

  @override
  Future<IdeaGroup?> getById(EntityId id) async => null;

  @override
  Future<List<IdeaGroup>> listActiveByApp(EntityId appId) async => [];

  @override
  Future<IdeaGroup> rename(EntityId id, String name, DateTime updatedAt) {
    throw UnimplementedError();
  }
}

class FileSystemExceptionForTest implements Exception {
  const FileSystemExceptionForTest();
}
