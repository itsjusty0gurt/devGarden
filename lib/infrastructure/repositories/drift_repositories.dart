import 'package:drift/drift.dart';

import '../../domain/models/entities.dart' as domain;
import '../../domain/repositories/repositories.dart';
import '../database/app_database.dart';

class DriftWorkspaceRepository implements WorkspaceRepository {
  const DriftWorkspaceRepository(this._database);

  final AppDatabase _database;

  @override
  Future<domain.Workspace> create(domain.Workspace workspace) async {
    await _database
        .into(_database.workspaces)
        .insert(
          WorkspacesCompanion(
            id: Value(workspace.id.value),
            name: Value(workspace.name),
            createdAt: Value(workspace.createdAt),
            updatedAt: Value(workspace.updatedAt),
            sortOrder: Value(workspace.sortOrder),
            isDeleted: Value(workspace.isDeleted),
          ),
        );
    return workspace;
  }

  @override
  Future<List<domain.Workspace>> listActive() async {
    final query = _database.select(_database.workspaces)
      ..where((row) => row.isDeleted.equals(false))
      ..orderBy([
        (row) => OrderingTerm(expression: row.sortOrder),
        (row) => OrderingTerm(expression: row.createdAt),
      ]);
    return (await query.get()).map(_workspace).toList();
  }
}

class DriftProjectRepository implements ProjectRepository {
  const DriftProjectRepository(this._database);

  final AppDatabase _database;

  @override
  Future<domain.Project> create(domain.Project project) async {
    await _database
        .into(_database.projects)
        .insert(
          ProjectsCompanion(
            id: Value(project.id.value),
            workspaceId: Value(project.workspaceId.value),
            name: Value(project.name),
            createdAt: Value(project.createdAt),
            updatedAt: Value(project.updatedAt),
            sortOrder: Value(project.sortOrder),
            isDeleted: Value(project.isDeleted),
          ),
        );
    return project;
  }

  @override
  Future<List<domain.Project>> listActiveByWorkspace(
    domain.EntityId workspaceId,
  ) async {
    final query = _database.select(_database.projects)
      ..where(
        (row) =>
            row.workspaceId.equals(workspaceId.value) &
            row.isDeleted.equals(false),
      )
      ..orderBy([
        (row) => OrderingTerm(expression: row.sortOrder),
        (row) => OrderingTerm(expression: row.createdAt),
      ]);
    return (await query.get()).map(_project).toList();
  }
}

class DriftAppRepository implements AppRepository {
  const DriftAppRepository(this._database);

  final AppDatabase _database;

  @override
  Future<domain.GardenApp> create(domain.GardenApp app) async {
    await _database
        .into(_database.apps)
        .insert(
          AppsCompanion(
            id: Value(app.id.value),
            projectId: Value(app.projectId.value),
            name: Value(app.name),
            createdAt: Value(app.createdAt),
            updatedAt: Value(app.updatedAt),
            sortOrder: Value(app.sortOrder),
            isDeleted: Value(app.isDeleted),
          ),
        );
    return app;
  }

  @override
  Future<List<domain.GardenApp>> listActiveByProject(
    domain.EntityId projectId,
  ) async {
    final query = _database.select(_database.apps)
      ..where(
        (row) =>
            row.projectId.equals(projectId.value) & row.isDeleted.equals(false),
      )
      ..orderBy([
        (row) => OrderingTerm(expression: row.sortOrder),
        (row) => OrderingTerm(expression: row.createdAt),
      ]);
    return (await query.get()).map(_app).toList();
  }
}

class DriftIdeaGroupRepository implements IdeaGroupRepository {
  const DriftIdeaGroupRepository(this._database);

  final AppDatabase _database;

  @override
  Future<domain.IdeaGroup> create(domain.IdeaGroup group) async {
    await _database
        .into(_database.ideaGroups)
        .insert(
          IdeaGroupsCompanion(
            id: Value(group.id.value),
            appId: Value(group.appId.value),
            name: Value(group.name),
            createdAt: Value(group.createdAt),
            updatedAt: Value(group.updatedAt),
            sortOrder: Value(group.sortOrder),
            isDeleted: Value(group.isDeleted),
          ),
        );
    return group;
  }

  @override
  Future<domain.IdeaGroup?> getById(domain.EntityId id) async {
    final query = _database.select(_database.ideaGroups)
      ..where((row) => row.id.equals(id.value));
    final row = await query.getSingleOrNull();
    return row == null ? null : _ideaGroup(row);
  }

  @override
  Future<List<domain.IdeaGroup>> listActiveByApp(domain.EntityId appId) async {
    final query = _database.select(_database.ideaGroups)
      ..where(
        (row) => row.appId.equals(appId.value) & row.isDeleted.equals(false),
      )
      ..orderBy([
        (row) => OrderingTerm(expression: row.sortOrder),
        (row) => OrderingTerm(expression: row.createdAt),
      ]);
    return (await query.get()).map(_ideaGroup).toList();
  }

  @override
  Future<domain.IdeaGroup> rename(
    domain.EntityId id,
    String name,
    DateTime updatedAt,
  ) async {
    final changed =
        await (_database.update(
          _database.ideaGroups,
        )..where((row) => row.id.equals(id.value))).write(
          IdeaGroupsCompanion(name: Value(name), updatedAt: Value(updatedAt)),
        );
    if (changed != 1) throw StateError('The Idea Group could not be renamed.');
    final updated = await getById(id);
    if (updated == null) {
      throw StateError('The Idea Group could not be reloaded.');
    }
    return updated;
  }

  @override
  Future<void> archiveAndUngroup(domain.EntityId id, DateTime updatedAt) {
    return _database.transaction(() async {
      final group = await getById(id);
      if (group == null || group.isDeleted) {
        throw StateError('The Idea Group is unavailable.');
      }
      await (_database.update(_database.ideas)..where(
            (row) => row.groupId.equals(id.value) & row.isDeleted.equals(false),
          ))
          .write(
            IdeasCompanion(
              groupId: const Value(null),
              updatedAt: Value(updatedAt),
            ),
          );
      final changed =
          await (_database.update(
            _database.ideaGroups,
          )..where((row) => row.id.equals(id.value))).write(
            IdeaGroupsCompanion(
              isDeleted: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
      if (changed != 1) {
        throw StateError('The Idea Group could not be archived.');
      }
    });
  }
}

class DriftIdeaRepository implements IdeaRepository {
  const DriftIdeaRepository(this._database);

  final AppDatabase _database;

  @override
  Future<domain.Idea> create(domain.Idea idea) async {
    await _database
        .into(_database.ideas)
        .insert(
          IdeasCompanion(
            id: Value(idea.id.value),
            appId: Value(idea.appId.value),
            groupId: Value(idea.groupId?.value),
            title: Value(idea.title),
            body: Value(idea.body),
            lifecycle: Value(idea.lifecycle.name),
            createdAt: Value(idea.createdAt),
            updatedAt: Value(idea.updatedAt),
            sortOrder: Value(idea.sortOrder),
            isPinned: Value(idea.isPinned),
            isDeleted: Value(idea.isDeleted),
          ),
        );
    return idea;
  }

  @override
  Future<domain.Idea?> getById(domain.EntityId id) async {
    final query = _database.select(_database.ideas)
      ..where((row) => row.id.equals(id.value));
    final row = await query.getSingleOrNull();
    return row == null ? null : _idea(row);
  }

  @override
  Future<List<domain.Idea>> listActiveByApp(domain.EntityId appId) {
    return _activeIdeaQuery(
      appId,
    ).get().then((rows) => rows.map(_idea).toList());
  }

  @override
  Future<List<domain.Idea>> listActiveUngroupedByApp(
    domain.EntityId appId,
  ) async {
    final query = _activeIdeaQuery(appId)..where((row) => row.groupId.isNull());
    return (await query.get()).map(_idea).toList();
  }

  @override
  Future<List<domain.Idea>> listActiveByGroup(domain.EntityId groupId) async {
    final query = _database.select(_database.ideas)
      ..where(
        (row) =>
            row.groupId.equals(groupId.value) & row.isDeleted.equals(false),
      )
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.updatedAt, mode: OrderingMode.desc),
      ]);
    return (await query.get()).map(_idea).toList();
  }

  @override
  Future<domain.Idea> assignToGroup({
    required domain.EntityId id,
    required domain.EntityId? groupId,
    required DateTime updatedAt,
  }) async {
    final changed =
        await (_database.update(
          _database.ideas,
        )..where((row) => row.id.equals(id.value))).write(
          IdeasCompanion(
            groupId: Value(groupId?.value),
            updatedAt: Value(updatedAt),
          ),
        );
    if (changed != 1) throw StateError('The Idea could not be moved.');
    final updated = await getById(id);
    if (updated == null) throw StateError('The Idea could not be reloaded.');
    return updated;
  }

  @override
  Future<List<domain.Idea>> search(domain.EntityId appId, String query) async {
    final pattern = '%${_escapeLike(query)}%';
    final select = _activeIdeaQuery(appId)
      ..where(
        (row) =>
            row.title.like(pattern, escapeChar: r'\') |
            row.body.like(pattern, escapeChar: r'\'),
      );
    return (await select.get()).map(_idea).toList();
  }

  @override
  Future<domain.Idea> updateContent({
    required domain.EntityId id,
    required String title,
    required String body,
    required DateTime updatedAt,
  }) async {
    final changed =
        await (_database.update(
          _database.ideas,
        )..where((row) => row.id.equals(id.value))).write(
          IdeasCompanion(
            title: Value(title),
            body: Value(body),
            updatedAt: Value(updatedAt),
          ),
        );
    if (changed != 1) {
      throw StateError('The Idea could not be updated.');
    }
    final updated = await getById(id);
    if (updated == null) {
      throw StateError('The Idea could not be reloaded.');
    }
    return updated;
  }

  @override
  Future<void> softDelete(domain.EntityId id, DateTime updatedAt) async {
    final changed =
        await (_database.update(
          _database.ideas,
        )..where((row) => row.id.equals(id.value))).write(
          IdeasCompanion(
            isDeleted: const Value(true),
            updatedAt: Value(updatedAt),
          ),
        );
    if (changed != 1) {
      throw StateError('The Idea could not be archived.');
    }
  }

  SimpleSelectStatement<$IdeasTable, IdeaRow> _activeIdeaQuery(
    domain.EntityId appId,
  ) {
    return _database.select(_database.ideas)
      ..where(
        (row) => row.appId.equals(appId.value) & row.isDeleted.equals(false),
      )
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.updatedAt, mode: OrderingMode.desc),
      ]);
  }

  String _escapeLike(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }
}

domain.Workspace _workspace(WorkspaceRow row) => domain.Workspace(
  id: domain.EntityId(row.id),
  name: row.name,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  sortOrder: row.sortOrder,
  isDeleted: row.isDeleted,
);

domain.Project _project(ProjectRow row) => domain.Project(
  id: domain.EntityId(row.id),
  workspaceId: domain.EntityId(row.workspaceId),
  name: row.name,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  sortOrder: row.sortOrder,
  isDeleted: row.isDeleted,
);

domain.GardenApp _app(AppRow row) => domain.GardenApp(
  id: domain.EntityId(row.id),
  projectId: domain.EntityId(row.projectId),
  name: row.name,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  sortOrder: row.sortOrder,
  isDeleted: row.isDeleted,
);

domain.IdeaGroup _ideaGroup(IdeaGroupRow row) => domain.IdeaGroup(
  id: domain.EntityId(row.id),
  appId: domain.EntityId(row.appId),
  name: row.name,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  sortOrder: row.sortOrder,
  isDeleted: row.isDeleted,
);

domain.Idea _idea(IdeaRow row) => domain.Idea(
  id: domain.EntityId(row.id),
  appId: domain.EntityId(row.appId),
  groupId: row.groupId == null ? null : domain.EntityId(row.groupId!),
  title: row.title,
  body: row.body,
  lifecycle: domain.IdeaLifecycle.values.byName(row.lifecycle),
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  sortOrder: row.sortOrder,
  isPinned: row.isPinned,
  isDeleted: row.isDeleted,
);
