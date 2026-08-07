import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/entities.dart';
import 'hierarchy_controller.dart';
import 'idea_controller.dart';

class GardenHomeView extends ConsumerWidget {
  const GardenHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hierarchy = ref.watch(hierarchyControllerProvider);
    final ideas = ref.watch(ideaControllerProvider);

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

    return _IdeasView(state: ideas);
  }
}

class _IdeasView extends ConsumerWidget {
  const _IdeasView({required this.state});

  final IdeaState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(ideaControllerProvider.notifier);
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
                onPressed: () => _capture(context, controller),
                icon: const Icon(Icons.add),
                label: const Text('New Idea'),
              ),
            ],
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
                : state.ideas.isEmpty
                ? Center(
                    child: Text(
                      state.searchQuery.isEmpty
                          ? 'No Ideas yet. Capture one whenever you are ready.'
                          : 'No matching Ideas.',
                    ),
                  )
                : ListView.separated(
                    itemCount: state.ideas.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) => _IdeaTile(
                      idea: state.ideas[index],
                      onOpen: () =>
                          context.go('/idea/${state.ideas[index].id.value}'),
                      onArchive: () => _confirmArchive(
                        context,
                        controller,
                        state.ideas[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _capture(BuildContext context, IdeaController controller) async {
    try {
      final idea = await controller.capture();
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
  });

  final Idea idea;
  final VoidCallback onOpen;
  final VoidCallback onArchive;

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
        trailing: IconButton(
          tooltip: 'Archive ${idea.title}',
          onPressed: onArchive,
          icon: const Icon(Icons.archive_outlined),
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
