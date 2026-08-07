import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/entities.dart';
import '../garden/hierarchy_controller.dart';

class ProjectExplorer extends ConsumerWidget {
  const ProjectExplorer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hierarchyControllerProvider);
    final controller = ref.read(hierarchyControllerProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'PROJECT EXPLORER',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('create-workspace-button'),
                  tooltip: 'Create Workspace',
                  onPressed: () => _createWorkspace(context, controller),
                  icon: const Icon(Icons.create_new_folder_outlined, size: 18),
                ),
              ],
            ),
          ),
          if (state.errorMessage case final message?)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message,
                style: TextStyle(color: colors.error, fontSize: 12),
              ),
            ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.workspaces.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('No Workspaces yet.'),
                          const SizedBox(height: 10),
                          FilledButton.icon(
                            key: const Key('empty-create-workspace-button'),
                            onPressed: () =>
                                _createWorkspace(context, controller),
                            icon: const Icon(Icons.add),
                            label: const Text('Create Workspace'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      for (final workspace in state.workspaces)
                        _workspaceNode(context, state, controller, workspace),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _workspaceNode(
    BuildContext context,
    HierarchyState state,
    HierarchyController controller,
    Workspace workspace,
  ) {
    final projects = state.projectsFor(workspace.id);
    return ExpansionTile(
      key: ValueKey('workspace-${workspace.id.value}'),
      initiallyExpanded: true,
      leading: const Icon(Icons.workspaces_outline, size: 18),
      title: Text(workspace.name),
      trailing: IconButton(
        tooltip: 'Create Project in ${workspace.name}',
        onPressed: () => _createProject(context, controller, workspace.id),
        icon: const Icon(Icons.create_new_folder_outlined, size: 18),
      ),
      children: [
        if (projects.isEmpty)
          _createTile(
            label: 'Create Project',
            key: Key('create-project-${workspace.id.value}'),
            onTap: () => _createProject(context, controller, workspace.id),
          ),
        for (final project in projects)
          _projectNode(context, state, controller, project),
      ],
    );
  }

  Widget _projectNode(
    BuildContext context,
    HierarchyState state,
    HierarchyController controller,
    Project project,
  ) {
    final apps = state.appsFor(project.id);
    return ExpansionTile(
      key: ValueKey('project-${project.id.value}'),
      initiallyExpanded: true,
      leading: const Icon(Icons.folder_outlined, size: 18),
      title: Text(project.name),
      trailing: IconButton(
        tooltip: 'Create App in ${project.name}',
        onPressed: () => _createApp(context, controller, project.id),
        icon: const Icon(Icons.add_box_outlined, size: 18),
      ),
      children: [
        if (apps.isEmpty)
          _createTile(
            label: 'Create App',
            key: Key('create-app-${project.id.value}'),
            onTap: () => _createApp(context, controller, project.id),
          ),
        for (final app in apps)
          ListTile(
            key: ValueKey('app-${app.id.value}'),
            dense: true,
            selected: state.selectedAppId == app.id,
            leading: const Icon(Icons.apps_outlined, size: 18),
            title: Text(app.name),
            onTap: () {
              controller.selectApp(app.id);
              context.go('/app');
            },
          ),
      ],
    );
  }

  Widget _createTile({
    required String label,
    required Key key,
    required VoidCallback onTap,
  }) {
    return ListTile(
      key: key,
      dense: true,
      leading: const Icon(Icons.add, size: 18),
      title: Text(label),
      onTap: onTap,
    );
  }

  Future<void> _createWorkspace(
    BuildContext context,
    HierarchyController controller,
  ) async {
    final name = await _nameDialog(
      context,
      title: 'Create Workspace',
      label: 'Workspace name',
      fieldKey: const Key('workspace-name-field'),
    );
    if (name == null) return;
    try {
      await controller.createWorkspace(name);
    } catch (_) {}
  }

  Future<void> _createProject(
    BuildContext context,
    HierarchyController controller,
    EntityId workspaceId,
  ) async {
    final name = await _nameDialog(
      context,
      title: 'Create Project',
      label: 'Project name',
      fieldKey: const Key('project-name-field'),
    );
    if (name == null) return;
    try {
      await controller.createProject(workspaceId, name);
    } catch (_) {}
  }

  Future<void> _createApp(
    BuildContext context,
    HierarchyController controller,
    EntityId projectId,
  ) async {
    final name = await _nameDialog(
      context,
      title: 'Create App',
      label: 'App name',
      fieldKey: const Key('app-name-field'),
    );
    if (name == null) return;
    try {
      await controller.createApp(projectId, name);
      if (context.mounted) context.go('/app');
    } catch (_) {}
  }

  Future<String?> _nameDialog(
    BuildContext context, {
    required String title,
    required String label,
    required Key fieldKey,
  }) async {
    var name = '';
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          key: fieldKey,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
          onChanged: (value) => name = value,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) Navigator.pop(dialogContext, value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirm-name-button'),
            onPressed: () {
              if (name.trim().isNotEmpty) {
                Navigator.pop(dialogContext, name);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
    return result;
  }
}
