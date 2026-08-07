import '../../domain/models/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'id_generator.dart';

typedef Clock = DateTime Function();

class HierarchyService {
  const HierarchyService(
    this._workspaces,
    this._projects,
    this._apps,
    this._ids,
    this._clock,
  );

  final WorkspaceRepository _workspaces;
  final ProjectRepository _projects;
  final AppRepository _apps;
  final IdGenerator _ids;
  final Clock _clock;

  Future<Workspace> createWorkspace(String name, {int sortOrder = 0}) {
    final now = _clock().toUtc();
    return _workspaces.create(
      Workspace(
        id: _ids.next(),
        name: _requiredName(name),
        createdAt: now,
        updatedAt: now,
        sortOrder: sortOrder,
        isDeleted: false,
      ),
    );
  }

  Future<Project> createProject(
    EntityId workspaceId,
    String name, {
    int sortOrder = 0,
  }) {
    final now = _clock().toUtc();
    return _projects.create(
      Project(
        id: _ids.next(),
        workspaceId: workspaceId,
        name: _requiredName(name),
        createdAt: now,
        updatedAt: now,
        sortOrder: sortOrder,
        isDeleted: false,
      ),
    );
  }

  Future<GardenApp> createApp(
    EntityId projectId,
    String name, {
    int sortOrder = 0,
  }) {
    final now = _clock().toUtc();
    return _apps.create(
      GardenApp(
        id: _ids.next(),
        projectId: projectId,
        name: _requiredName(name),
        createdAt: now,
        updatedAt: now,
        sortOrder: sortOrder,
        isDeleted: false,
      ),
    );
  }

  String _requiredName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('A name is required.');
    }
    return trimmed;
  }
}
