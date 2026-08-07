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

abstract interface class IdeaRepository {
  Future<Idea> create(Idea idea);
  Future<Idea?> getById(EntityId id);
  Future<List<Idea>> listActiveByApp(EntityId appId);
  Future<Idea> updateContent({
    required EntityId id,
    required String title,
    required String body,
    required DateTime updatedAt,
  });
  Future<void> softDelete(EntityId id, DateTime updatedAt);
  Future<List<Idea>> search(EntityId appId, String query);
}
