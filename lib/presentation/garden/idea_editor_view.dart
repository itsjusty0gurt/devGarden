import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/entities.dart';
import 'idea_controller.dart';

class IdeaEditorView extends ConsumerStatefulWidget {
  const IdeaEditorView({required this.ideaId, super.key});

  final String ideaId;

  @override
  ConsumerState<IdeaEditorView> createState() => _IdeaEditorViewState();
}

class _IdeaEditorViewState extends ConsumerState<IdeaEditorView> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _bodyFocus = FocusNode();
  late final IdeaController _ideaController;
  String? _loadedIdeaId;

  @override
  void initState() {
    super.initState();
    _ideaController = ref.read(ideaControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_ideaController.open(EntityId(widget.ideaId)));
      _bodyFocus.requestFocus();
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
      _bodyController.text = state.draftBody;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _bodyFocus.requestFocus();
      });
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
                  onChanged: (_) => _draftChanged(controller),
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
          Expanded(
            child: TextField(
              key: const Key('idea-body-field'),
              controller: _bodyController,
              focusNode: _bodyFocus,
              autofocus: true,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'Start writing…',
                alignLabelWithHint: true,
              ),
              onChanged: (_) => _draftChanged(controller),
            ),
          ),
        ],
      ),
    );
  }

  void _draftChanged(IdeaController controller) {
    controller.updateDraft(
      title: _titleController.text,
      body: _bodyController.text,
    );
  }

  Future<void> _leaveEditor(
    BuildContext context,
    IdeaController controller,
  ) async {
    await controller.flush();
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
      await controller.softDelete(idea.id);
      if (context.mounted) context.go('/app');
    }
  }

  @override
  void dispose() {
    unawaited(_ideaController.flush());
    _titleController.dispose();
    _bodyController.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }
}
