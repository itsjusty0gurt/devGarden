import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../application/services/hierarchy_service.dart';
import '../../domain/models/entities.dart';
import '../../domain/repositories/repositories.dart';

class HierarchyState {
  const HierarchyState({
    this.workspaces = const [],
    this.projects = const [],
    this.apps = const [],
    this.selectedWorkspaceId,
    this.selectedProjectId,
    this.selectedAppId,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Workspace> workspaces;
  final List<Project> projects;
  final List<GardenApp> apps;
  final EntityId? selectedWorkspaceId;
  final EntityId? selectedProjectId;
  final EntityId? selectedAppId;
  final bool isLoading;
  final String? errorMessage;

  HierarchyState copyWith({
    List<Workspace>? workspaces,
    List<Project>? projects,
    List<GardenApp>? apps,
    EntityId? selectedWorkspaceId,
    EntityId? selectedProjectId,
    EntityId? selectedAppId,
    bool clearSelectedApp = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HierarchyState(
      workspaces: workspaces ?? this.workspaces,
      projects: projects ?? this.projects,
      apps: apps ?? this.apps,
      selectedWorkspaceId: selectedWorkspaceId ?? this.selectedWorkspaceId,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      selectedAppId: clearSelectedApp
          ? null
          : selectedAppId ?? this.selectedAppId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  List<Project> projectsFor(EntityId workspaceId) => projects
      .where((project) => project.workspaceId == workspaceId)
      .toList(growable: false);

  List<GardenApp> appsFor(EntityId projectId) =>
      apps.where((app) => app.projectId == projectId).toList(growable: false);
}

final hierarchyControllerProvider =
    StateNotifierProvider<HierarchyController, HierarchyState>((ref) {
      final controller = HierarchyController(
        ref.watch(hierarchyServiceProvider),
        ref.watch(workspaceRepositoryProvider),
        ref.watch(projectRepositoryProvider),
        ref.watch(appRepositoryProvider),
      );
      unawaited(controller.load());
      return controller;
    });

final selectedAppIdProvider = Provider<EntityId?>(
  (ref) => ref.watch(
    hierarchyControllerProvider.select((state) => state.selectedAppId),
  ),
);

class HierarchyController extends StateNotifier<HierarchyState> {
  HierarchyController(
    this._service,
    this._workspaces,
    this._projects,
    this._apps,
  ) : super(const HierarchyState());

  final HierarchyService _service;
  final WorkspaceRepository _workspaces;
  final ProjectRepository _projects;
  final AppRepository _apps;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final workspaces = await _workspaces.listActive();
      final projects = <Project>[];
      final apps = <GardenApp>[];
      for (final workspace in workspaces) {
        final workspaceProjects = await _projects.listActiveByWorkspace(
          workspace.id,
        );
        projects.addAll(workspaceProjects);
        for (final project in workspaceProjects) {
          apps.addAll(await _apps.listActiveByProject(project.id));
        }
      }

      final selectedApp = _preservedOrFirst(state.selectedAppId, apps);
      final selectedProject = selectedApp == null
          ? _preservedOrFirst(state.selectedProjectId, projects)
          : projects.where((item) => item.id == selectedApp.projectId).first;
      final selectedWorkspace = selectedProject == null
          ? _preservedOrFirst(state.selectedWorkspaceId, workspaces)
          : workspaces
                .where((item) => item.id == selectedProject.workspaceId)
                .first;

      state = HierarchyState(
        workspaces: workspaces,
        projects: projects,
        apps: apps,
        selectedWorkspaceId: selectedWorkspace?.id,
        selectedProjectId: selectedProject?.id,
        selectedAppId: selectedApp?.id,
      );
    } catch (error, stackTrace) {
      _report('Could not load your workspace hierarchy.', error, stackTrace);
    }
  }

  Future<Workspace> createWorkspace(String name) async {
    try {
      final workspace = await _service.createWorkspace(
        name,
        sortOrder: state.workspaces.length,
      );
      state = state.copyWith(
        workspaces: [...state.workspaces, workspace],
        selectedWorkspaceId: workspace.id,
        clearError: true,
      );
      return workspace;
    } catch (error, stackTrace) {
      _report('Could not create the Workspace.', error, stackTrace);
      rethrow;
    }
  }

  Future<Project> createProject(EntityId workspaceId, String name) async {
    try {
      final project = await _service.createProject(
        workspaceId,
        name,
        sortOrder: state.projectsFor(workspaceId).length,
      );
      state = state.copyWith(
        projects: [...state.projects, project],
        selectedWorkspaceId: workspaceId,
        selectedProjectId: project.id,
        clearError: true,
      );
      return project;
    } catch (error, stackTrace) {
      _report('Could not create the Project.', error, stackTrace);
      rethrow;
    }
  }

  Future<GardenApp> createApp(EntityId projectId, String name) async {
    try {
      final app = await _service.createApp(
        projectId,
        name,
        sortOrder: state.appsFor(projectId).length,
      );
      final project = state.projects
          .where((item) => item.id == projectId)
          .first;
      state = state.copyWith(
        apps: [...state.apps, app],
        selectedWorkspaceId: project.workspaceId,
        selectedProjectId: projectId,
        selectedAppId: app.id,
        clearError: true,
      );
      return app;
    } catch (error, stackTrace) {
      _report('Could not create the App.', error, stackTrace);
      rethrow;
    }
  }

  void selectApp(EntityId id) {
    final app = state.apps.where((item) => item.id == id).first;
    final project = state.projects
        .where((item) => item.id == app.projectId)
        .first;
    state = state.copyWith(
      selectedWorkspaceId: project.workspaceId,
      selectedProjectId: project.id,
      selectedAppId: app.id,
      clearError: true,
    );
  }

  T? _preservedOrFirst<T>(EntityId? selected, List<T> values) {
    if (values.isEmpty) return null;
    if (selected == null) return values.first;
    for (final value in values) {
      final id = switch (value) {
        Workspace item => item.id,
        Project item => item.id,
        GardenApp item => item.id,
        _ => null,
      };
      if (id == selected) return value;
    }
    return values.first;
  }

  void _report(String message, Object error, StackTrace stackTrace) {
    developer.log(
      message,
      name: 'devGarden.hierarchy',
      error: error,
      stackTrace: stackTrace,
    );
    state = state.copyWith(isLoading: false, errorMessage: message);
  }
}
