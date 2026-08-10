import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/entities.dart';
import '../branding/devgarden_logo.dart';
import '../garden/content_block_controller.dart';
import '../garden/hierarchy_controller.dart';
import '../garden/idea_controller.dart';
import '../garden/idea_group_controller.dart';
import '../garden/idea_workspace_controller.dart';
import 'explorer_tree.dart';

class ProjectExplorer extends ConsumerWidget {
  const ProjectExplorer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hierarchy = ref.watch(hierarchyControllerProvider);
    final liveIdeas = ref.watch(ideaControllerProvider);
    final liveGroups = ref.watch(ideaGroupControllerProvider);
    final hierarchyController = ref.read(hierarchyControllerProvider.notifier);
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
                const BrandMark(
                  key: Key('devgarden-project-explorer-mark'),
                  size: 22,
                ),
                const SizedBox(width: 8),
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
                  onPressed: () =>
                      _createWorkspace(context, hierarchyController),
                  icon: const Icon(Icons.create_new_folder_outlined, size: 18),
                ),
              ],
            ),
          ),
          if (hierarchy.errorMessage case final message?)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message,
                style: TextStyle(color: colors.error, fontSize: 12),
              ),
            ),
          Expanded(
            child: hierarchy.isLoading
                ? const Center(child: CircularProgressIndicator())
                : hierarchy.workspaces.isEmpty
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
                                _createWorkspace(context, hierarchyController),
                            icon: const Icon(Icons.add),
                            label: const Text('Create Workspace'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ExplorerTree(
                    nodes: _nodes(
                      context,
                      ref,
                      hierarchy,
                      liveIdeas,
                      liveGroups,
                      hierarchyController,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<ExplorerNode> _nodes(
    BuildContext context,
    WidgetRef ref,
    HierarchyState hierarchy,
    IdeaState liveIdeas,
    IdeaGroupState liveGroups,
    HierarchyController controller,
  ) {
    return [
      for (final workspace in hierarchy.workspaces)
        ExplorerNode(
          key: 'workspace-${workspace.id.value}',
          type: ExplorerNodeType.workspace,
          title: workspace.name,
          icon: Icons.workspaces_outline,
          trailing: IconButton(
            tooltip: 'Create Project in ${workspace.name}',
            onPressed: () => _createProject(context, controller, workspace.id),
            icon: const Icon(Icons.create_new_folder_outlined, size: 16),
          ),
          children: [
            for (final project in hierarchy.projectsFor(workspace.id))
              ExplorerNode(
                key: 'project-${project.id.value}',
                type: ExplorerNodeType.project,
                title: project.name,
                icon: Icons.folder_outlined,
                trailing: IconButton(
                  tooltip: 'Create App in ${project.name}',
                  onPressed: () => _createApp(context, controller, project.id),
                  icon: const Icon(Icons.add_box_outlined, size: 16),
                ),
                children: [
                  for (final app in hierarchy.appsFor(project.id))
                    _appNode(
                      context,
                      ref,
                      hierarchy,
                      liveIdeas,
                      liveGroups,
                      controller,
                      app,
                    ),
                  if (hierarchy.appsFor(project.id).isEmpty)
                    ExplorerNode(
                      key: 'create-app-${project.id.value}',
                      type: ExplorerNodeType.action,
                      title: 'Create App',
                      icon: Icons.add,
                      onActivate: () =>
                          _createApp(context, controller, project.id),
                    ),
                ],
              ),
            if (hierarchy.projectsFor(workspace.id).isEmpty)
              ExplorerNode(
                key: 'create-project-${workspace.id.value}',
                type: ExplorerNodeType.action,
                title: 'Create Project',
                icon: Icons.add,
                onActivate: () =>
                    _createProject(context, controller, workspace.id),
              ),
          ],
        ),
    ];
  }

  ExplorerNode _appNode(
    BuildContext context,
    WidgetRef ref,
    HierarchyState hierarchy,
    IdeaState liveIdeas,
    IdeaGroupState liveGroups,
    HierarchyController controller,
    GardenApp app,
  ) {
    final isLive =
        hierarchy.selectedAppId == app.id && liveIdeas.appId == app.id;
    final ideas = isLive ? liveIdeas.allIdeas : hierarchy.ideasFor(app.id);
    final groups = isLive && liveGroups.appId == app.id
        ? liveGroups.groups
        : hierarchy.groupsFor(app.id);
    final ungrouped = ideas.where((idea) => idea.groupId == null).toList();
    return ExplorerNode(
      key: 'app-${app.id.value}',
      type: ExplorerNodeType.app,
      title: app.name,
      icon: Icons.apps_outlined,
      selected: hierarchy.selectedAppId == app.id,
      onActivate: () async {
        await _selectApp(ref, controller, app.id);
        ref.read(ideaGroupControllerProvider.notifier).showAll();
        if (context.mounted) context.go('/app');
      },
      children: [
        for (final group in groups)
          ExplorerNode(
            key: 'group-${group.id.value}',
            type: ExplorerNodeType.ideaGroup,
            title: group.name,
            icon: Icons.folder_open_outlined,
            selected:
                hierarchy.selectedAppId == app.id &&
                liveGroups.filter == IdeaGroupFilter.group &&
                liveGroups.selectedGroupId == group.id,
            onActivate: () async {
              await _selectApp(ref, controller, app.id);
              ref
                  .read(ideaGroupControllerProvider.notifier)
                  .showGroup(group.id);
              if (context.mounted) context.go('/app');
            },
            children: [
              for (final idea in ideas.where(
                (idea) => idea.groupId == group.id,
              ))
                _ideaNode(context, ref, controller, app.id, idea),
            ],
          ),
        if (ungrouped.isNotEmpty)
          ExplorerNode(
            key: 'ungrouped-${app.id.value}',
            type: ExplorerNodeType.ungrouped,
            title: 'Ungrouped',
            icon: Icons.inbox_outlined,
            selected:
                hierarchy.selectedAppId == app.id &&
                liveGroups.filter == IdeaGroupFilter.ungrouped,
            onActivate: () async {
              await _selectApp(ref, controller, app.id);
              ref.read(ideaGroupControllerProvider.notifier).showUngrouped();
              if (context.mounted) context.go('/app');
            },
            children: [
              for (final idea in ungrouped)
                _ideaNode(context, ref, controller, app.id, idea),
            ],
          ),
      ],
    );
  }

  ExplorerNode _ideaNode(
    BuildContext context,
    WidgetRef ref,
    HierarchyController hierarchy,
    EntityId appId,
    Idea idea,
  ) {
    return ExplorerNode(
      key: 'explorer-idea-${idea.id.value}',
      type: ExplorerNodeType.idea,
      title: idea.title,
      icon: Icons.lightbulb_outline,
      onActivate: () async {
        await _selectApp(ref, hierarchy, appId);
        final groups = ref.read(ideaGroupControllerProvider.notifier);
        if (idea.groupId case final groupId?) {
          groups.showGroup(groupId);
        } else {
          groups.showUngrouped();
        }
        ref.read(ideaWorkspaceControllerProvider.notifier).reveal(idea.id);
        if (context.mounted) context.go('/app');
      },
    );
  }

  Future<void> _selectApp(
    WidgetRef ref,
    HierarchyController hierarchy,
    EntityId appId,
  ) async {
    await ref.read(contentBlockSessionCoordinatorProvider.notifier).flushAll();
    hierarchy.selectApp(appId);
    await Future.wait([
      ref.read(ideaControllerProvider.notifier).selectApp(appId),
      ref.read(ideaGroupControllerProvider.notifier).selectApp(appId),
    ]);
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
    return showDialog<String>(
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
              if (name.trim().isNotEmpty) Navigator.pop(dialogContext, name);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
