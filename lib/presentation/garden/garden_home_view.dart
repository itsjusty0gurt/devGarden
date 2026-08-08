import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/entities.dart';
import 'hierarchy_controller.dart';
import 'idea_controller.dart';
import 'idea_group_controller.dart';

class GardenHomeView extends ConsumerWidget {
  const GardenHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hierarchy = ref.watch(hierarchyControllerProvider);
    final ideas = ref.watch(ideaControllerProvider);
    final groups = ref.watch(ideaGroupControllerProvider);

    if (hierarchy.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (hierarchy.errorMessage case final message?) {
      return _ErrorState(
        message: message,
        onRetry: () => ref.read(hierarchyControllerProvider.notifier).load(),
      );
    }
    if (hierarchy.workspaces.isEmpty) {
      return const _GuidanceState(
        icon: Icons.workspaces_outline,
        title: 'Create your first Workspace',
        message: 'Use Create Workspace in the Project Explorer to begin.',
      );
    }
    if (hierarchy.selectedAppId == null) {
      return const _GuidanceState(
        icon: Icons.apps_outlined,
        title: 'Create or select an App',
        message: 'Ideas belong to an App. No other metadata is required.',
      );
    }

    return _IdeasView(state: ideas, groupState: groups);
  }
}

class _IdeasView extends ConsumerWidget {
  const _IdeasView({required this.state, required this.groupState});

  final IdeaState state;
  final IdeaGroupState groupState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(ideaControllerProvider.notifier);
    final groupController = ref.read(ideaGroupControllerProvider.notifier);
    final visibleIdeas = state.searchQuery.trim().isNotEmpty
        ? state.ideas
        : switch (groupState.filter) {
            IdeaGroupFilter.all => state.ideas,
            IdeaGroupFilter.ungrouped =>
              state.ideas
                  .where((idea) => idea.groupId == null)
                  .toList(growable: false),
            IdeaGroupFilter.group =>
              state.ideas
                  .where((idea) => idea.groupId == groupState.selectedGroupId)
                  .toList(growable: false),
          };
    return Padding(
      key: const Key('ideas-view'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ideas',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              FilledButton.icon(
                key: const Key('new-idea-button'),
                onPressed: () => _capture(context, controller, groupController),
                icon: const Icon(Icons.add),
                label: const Text('New Idea'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('All Ideas'),
                selected: groupState.filter == IdeaGroupFilter.all,
                onSelected: (_) => groupController.showAll(),
              ),
              ChoiceChip(
                label: const Text('Ungrouped'),
                selected: groupState.filter == IdeaGroupFilter.ungrouped,
                onSelected: (_) => groupController.showUngrouped(),
              ),
              for (final group in groupState.groups)
                ChoiceChip(
                  key: ValueKey('idea-group-${group.id.value}'),
                  label: Text(group.name),
                  selected:
                      groupState.filter == IdeaGroupFilter.group &&
                      groupState.selectedGroupId == group.id,
                  onSelected: (_) => groupController.showGroup(group.id),
                ),
              OutlinedButton.icon(
                key: const Key('create-idea-group'),
                onPressed: () => _nameGroup(context, groupController),
                icon: const Icon(Icons.create_new_folder_outlined),
                label: const Text('New Group'),
              ),
              if (groupState.filter == IdeaGroupFilter.group)
                PopupMenuButton<String>(
                  tooltip: 'Group actions',
                  onSelected: (action) =>
                      _groupAction(context, ref, groupController, action),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'rename', child: Text('Rename Group')),
                    PopupMenuItem(
                      value: 'archive',
                      child: Text('Archive Group'),
                    ),
                  ],
                ),
            ],
          ),
          if (state.searchQuery.trim().isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Search includes every active Idea in this App.'),
            ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('idea-search-field'),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search this App',
              hintText: 'Search titles and text',
            ),
            onChanged: (value) => unawaited(controller.search(value)),
          ),
          const SizedBox(height: 14),
          if (state.errorMessage case final message?)
            _InlineError(message: message, onRetry: controller.refresh),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : visibleIdeas.isEmpty
                ? Center(
                    child: Text(
                      state.searchQuery.isEmpty
                          ? 'No Ideas yet. Capture one whenever you are ready.'
                          : 'No matching Ideas.',
                    ),
                  )
                : ListView.separated(
                    itemCount: visibleIdeas.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) => _IdeaTile(
                      idea: visibleIdeas[index],
                      groups: groupState.groups,
                      onOpen: () =>
                          context.go('/idea/${visibleIdeas[index].id.value}'),
                      onMove: (groupId) => controller.moveToGroup(
                        visibleIdeas[index].id,
                        groupId,
                      ),
                      onArchive: () => _confirmArchive(
                        context,
                        controller,
                        visibleIdeas[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _nameGroup(
    BuildContext context,
    IdeaGroupController controller, {
    IdeaGroup? group,
  }) async {
    var enteredName = group?.name ?? '';
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(group == null ? 'New Idea Group' : 'Rename Idea Group'),
        content: TextFormField(
          key: const Key('idea-group-name-field'),
          initialValue: enteredName,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onChanged: (value) => enteredName = value,
          onFieldSubmitted: (value) => Navigator.pop(dialogContext, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, enteredName),
            child: Text(group == null ? 'Create' : 'Rename'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    if (group == null) {
      await controller.create(name);
    } else {
      await controller.rename(group.id, name);
    }
  }

  Future<void> _groupAction(
    BuildContext context,
    WidgetRef ref,
    IdeaGroupController controller,
    String action,
  ) async {
    final id = groupState.selectedGroupId;
    if (id == null) return;
    final group = groupState.groups.where((item) => item.id == id).first;
    if (action == 'rename') {
      await _nameGroup(context, controller, group: group);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archive Idea Group?'),
        content: Text(
          '“${group.name}” will be archived. Its Ideas will remain and become Ungrouped.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirm-archive-group'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.archive(id);
      await ref.read(ideaControllerProvider.notifier).refresh();
    }
  }

  Future<void> _capture(
    BuildContext context,
    IdeaController controller,
    IdeaGroupController groupController,
  ) async {
    try {
      final idea = await controller.capture();
      groupController.showUngrouped();
      if (context.mounted) context.go('/idea/${idea.id.value}');
    } catch (_) {
      // The controller exposes the concise user-facing failure.
    }
  }

  Future<void> _confirmArchive(
    BuildContext context,
    IdeaController controller,
    Idea idea,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archive Idea?'),
        content: Text('“${idea.title}” will leave normal lists and search.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirm-archive-idea'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.softDelete(idea.id);
  }
}

class _IdeaTile extends StatelessWidget {
  const _IdeaTile({
    required this.idea,
    required this.onOpen,
    required this.onArchive,
    required this.groups,
    required this.onMove,
  });

  final Idea idea;
  final VoidCallback onOpen;
  final VoidCallback onArchive;
  final List<IdeaGroup> groups;
  final Future<void> Function(EntityId? groupId) onMove;

  @override
  Widget build(BuildContext context) {
    final local = idea.updatedAt.toLocal();
    final updated =
        '${local.year}-${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        key: ValueKey('idea-${idea.id.value}'),
        leading: const Icon(Icons.lightbulb_outline),
        title: Text(idea.title),
        subtitle: Text('Updated $updated'),
        onTap: onOpen,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton<String>(
              tooltip: 'Move ${idea.title}',
              onSelected: (groupId) =>
                  unawaited(onMove(groupId.isEmpty ? null : EntityId(groupId))),
              itemBuilder: (_) => [
                const PopupMenuItem<String>(
                  value: '',
                  child: Text('Ungrouped'),
                ),
                for (final group in groups)
                  PopupMenuItem<String>(
                    value: group.id.value,
                    child: Text(group.name),
                  ),
              ],
              icon: const Icon(Icons.drive_file_move_outline),
            ),
            IconButton(
              tooltip: 'Archive ${idea.title}',
              onPressed: onArchive,
              icon: const Icon(Icons.archive_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidanceState extends StatelessWidget {
  const _GuidanceState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => unawaited(onRetry()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(message),
        trailing: TextButton(
          onPressed: () => unawaited(onRetry()),
          child: const Text('Retry'),
        ),
      ),
    );
  }
}
