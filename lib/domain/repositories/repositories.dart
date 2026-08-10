import '../models/entities.dart';

abstract interface class WorkspaceRepository {
  Future<Workspace> create(Workspace workspace);
  Future<List<Workspace>> listActive();
}

abstract interface class ProjectRepository {
  Future<Project> create(Project project);
  Future<List<Project>> listActiveByWorkspace(EntityId workspaceId);
}

abstract interface class AppRepository {
  Future<GardenApp> create(GardenApp app);
  Future<List<GardenApp>> listActiveByProject(EntityId projectId);
}

abstract interface class IdeaGroupRepository {
  Future<IdeaGroup> create(IdeaGroup group);
  Future<IdeaGroup?> getById(EntityId id);
  Future<List<IdeaGroup>> listActiveByApp(EntityId appId);
  Future<IdeaGroup> rename(EntityId id, String name, DateTime updatedAt);
  Future<void> archiveAndUngroup(EntityId id, DateTime updatedAt);
}

abstract interface class IdeaRepository {
  Future<Idea> create(Idea idea);
  Future<Idea?> getById(EntityId id);
  Future<List<Idea>> listActiveByApp(EntityId appId);
  Future<List<Idea>> listActiveUngroupedByApp(EntityId appId);
  Future<List<Idea>> listActiveByGroup(EntityId groupId);
  Future<Idea> assignToGroup({
    required EntityId id,
    required EntityId? groupId,
    required DateTime updatedAt,
  });
  Future<Idea> updateTitle({
    required EntityId id,
    required String title,
    required DateTime updatedAt,
  });
  Future<void> softDelete(EntityId id, DateTime updatedAt);
  Future<List<Idea>> search(EntityId appId, String query);
}

abstract interface class ContentBlockRepository {
  Future<ContentBlock> create(ContentBlock block);
  Future<ContentBlock?> getById(EntityId id);
  Future<List<ContentBlock>> listActiveByIdea(EntityId ideaId);
  Future<ContentBlock> update({
    required EntityId id,
    required ContentBlockType type,
    required String text,
    required Map<String, Object?> metadata,
    required DateTime updatedAt,
  });
  Future<void> reorder({
    required EntityId ideaId,
    required List<EntityId> orderedIds,
    required DateTime updatedAt,
  });
  Future<void> softDelete(EntityId id, DateTime updatedAt);
  Future<void> setDeleted(
    EntityId id, {
    required bool isDeleted,
    required DateTime updatedAt,
  });
}
