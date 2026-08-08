import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/entities.dart';
import 'content_block_controller.dart';
import 'content_block_editor.dart';
import 'idea_controller.dart';

class IdeaEditorView extends ConsumerStatefulWidget {
  const IdeaEditorView({required this.ideaId, super.key});

  final String ideaId;

  @override
  ConsumerState<IdeaEditorView> createState() => _IdeaEditorViewState();
}

class _IdeaEditorViewState extends ConsumerState<IdeaEditorView> {
  final _titleController = TextEditingController();
  late final IdeaController _ideaController;
  late final ContentBlockController _blockController;
  String? _loadedIdeaId;

  @override
  void initState() {
    super.initState();
    _ideaController = ref.read(ideaControllerProvider.notifier);
    _blockController = ref.read(contentBlockControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = EntityId(widget.ideaId);
      unawaited(_ideaController.open(id));
      unawaited(_blockController.openIdea(id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ideaControllerProvider);
    final controller = ref.read(ideaControllerProvider.notifier);
    final current = state.current;

    if (current?.id.value == widget.ideaId && _loadedIdeaId != widget.ideaId) {
      _loadedIdeaId = widget.ideaId;
      _titleController.text = state.draftTitle;
    }

    if (current?.id.value != widget.ideaId) {
      if (state.errorMessage case final message?) {
        return Center(child: Text(message));
      }
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      key: const Key('idea-editor-view'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back to Ideas',
                onPressed: () => _leaveEditor(context, controller),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  key: const Key('idea-title-field'),
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.headlineSmall,
                  onChanged: controller.updateDraftTitle,
                ),
              ),
              IconButton(
                tooltip: 'Archive Idea',
                onPressed: () => _archive(context, controller, current!),
                icon: const Icon(Icons.archive_outlined),
              ),
            ],
          ),
          if (state.errorMessage case final message?) ...[
            Material(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                leading: const Icon(Icons.error_outline),
                title: Text(message),
                trailing: TextButton(
                  onPressed: () => unawaited(controller.flush()),
                  child: const Text('Retry save'),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(child: ContentBlockEditor(ideaId: current!.id)),
        ],
      ),
    );
  }

  Future<void> _leaveEditor(
    BuildContext context,
    IdeaController controller,
  ) async {
    await Future.wait([controller.flush(), _blockController.flush()]);
    if (context.mounted) context.go('/app');
  }

  Future<void> _archive(
    BuildContext context,
    IdeaController controller,
    Idea idea,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archive Idea?'),
        content: const Text(
          'This Idea will leave normal lists and search. Its data is retained.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _blockController.flush();
      await controller.softDelete(idea.id);
      if (context.mounted) context.go('/app');
    }
  }

  @override
  void dispose() {
    unawaited(_ideaController.flush());
    unawaited(_blockController.flush());
    _titleController.dispose();
    super.dispose();
  }
}
