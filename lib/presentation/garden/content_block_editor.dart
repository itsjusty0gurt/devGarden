import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/entities.dart';
import 'content_block_controller.dart';

class ContentBlockEditor extends ConsumerWidget {
  const ContentBlockEditor({required this.ideaId, super.key});

  final EntityId ideaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contentBlockControllerProvider);
    final controller = ref.read(contentBlockControllerProvider.notifier);
    if (state.ideaId != ideaId || state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.errorMessage case final message?)
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
        Expanded(
          child: ListView.builder(
            key: const Key('block-list'),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.blocks.length,
            itemBuilder: (context, index) {
              final block = state.blocks[index];
              return _BlockSurface(
                key: ValueKey('block-${block.id.value}'),
                block: block,
                index: index,
                blockCount: state.blocks.length,
                focusEpoch: state.activeBlockId == block.id
                    ? state.focusEpoch
                    : -1,
                onActivate: () => controller.activate(block.id),
                onTextChanged: (value) =>
                    controller.updateText(block.id, value),
                onMetadataChanged: (value) =>
                    controller.updateMetadata(block.id, value),
                onChangeType: (type) => controller.changeType(block.id, type),
                onMove: (delta) => controller.move(block.id, delta),
                onDelete: () => controller.delete(block.id),
                onInsertParagraph: () => controller.add(
                  ContentBlockType.paragraph,
                  afterId: block.id,
                ),
                onInsertCode: () =>
                    controller.add(ContentBlockType.code, afterId: block.id),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: PopupMenuButton<ContentBlockType>(
            key: const Key('add-block-button'),
            tooltip: 'Add Block',
            onSelected: (type) =>
                unawaited(controller.add(type, afterId: state.activeBlockId)),
            itemBuilder: (_) => [
              for (final type in ContentBlockType.values)
                PopupMenuItem(value: type, child: Text(_typeLabel(type))),
            ],
            child: OutlinedButton.icon(
              onPressed: null,
              icon: Icon(Icons.add),
              label: Text('Add Block'),
            ),
          ),
        ),
      ],
    );
  }
}

class _BlockSurface extends StatefulWidget {
  const _BlockSurface({
    required this.block,
    required this.index,
    required this.blockCount,
    required this.focusEpoch,
    required this.onActivate,
    required this.onTextChanged,
    required this.onMetadataChanged,
    required this.onChangeType,
    required this.onMove,
    required this.onDelete,
    required this.onInsertParagraph,
    required this.onInsertCode,
    super.key,
  });

  final ContentBlock block;
  final int index;
  final int blockCount;
  final int focusEpoch;
  final VoidCallback onActivate;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<Map<String, Object?>> onMetadataChanged;
  final Future<void> Function(ContentBlockType type) onChangeType;
  final Future<void> Function(int delta) onMove;
  final Future<void> Function() onDelete;
  final Future<ContentBlock> Function() onInsertParagraph;
  final Future<ContentBlock> Function() onInsertCode;

  @override
  State<_BlockSurface> createState() => _BlockSurfaceState();
}

class _BlockSurfaceState extends State<_BlockSurface> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.block.text);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) widget.onActivate();
    });
    if (widget.focusEpoch >= 0) _requestFocus();
  }

  @override
  void didUpdateWidget(covariant _BlockSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.text != _textController.text) {
      _textController.value = TextEditingValue(
        text: widget.block.text,
        selection: TextSelection.collapsed(offset: widget.block.text.length),
      );
    }
    if (widget.focusEpoch >= 0 && widget.focusEpoch != oldWidget.focusEpoch) {
      _requestFocus();
    }
  }

  void _requestFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.block.type != ContentBlockType.divider) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, control: true): () =>
            unawaited(widget.onInsertParagraph()),
        const SingleActivator(
          LogicalKeyboardKey.keyC,
          control: true,
          shift: true,
        ): () =>
            unawaited(widget.onInsertCode()),
        const SingleActivator(LogicalKeyboardKey.arrowUp, alt: true): () =>
            unawaited(widget.onMove(-1)),
        const SingleActivator(LogicalKeyboardKey.arrowDown, alt: true): () =>
            unawaited(widget.onMove(1)),
        if (widget.block.type == ContentBlockType.code)
          const SingleActivator(LogicalKeyboardKey.tab): _insertIndent,
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _blockContent(context)),
            const SizedBox(width: 4),
            _BlockActions(
              block: widget.block,
              canMoveUp: widget.index > 0,
              canMoveDown: widget.index < widget.blockCount - 1,
              onChangeType: widget.onChangeType,
              onMove: widget.onMove,
              onDelete: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _blockContent(BuildContext context) {
    return switch (widget.block.type) {
      ContentBlockType.paragraph => _textField(
        key: ValueKey('block-text-${widget.block.id.value}'),
        hint: 'Start writing…',
        minLines: 1,
        maxLines: null,
        border: InputBorder.none,
      ),
      ContentBlockType.heading => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<int>(
            key: ValueKey('heading-level-${widget.block.id.value}'),
            value: widget.block.headingLevel.clamp(1, 3),
            items: const [
              DropdownMenuItem(value: 1, child: Text('H1')),
              DropdownMenuItem(value: 2, child: Text('H2')),
              DropdownMenuItem(value: 3, child: Text('H3')),
            ],
            onChanged: (level) {
              if (level != null) widget.onMetadataChanged({'level': level});
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _textField(
              key: ValueKey('block-text-${widget.block.id.value}'),
              hint: 'Heading',
              minLines: 1,
              maxLines: null,
              border: InputBorder.none,
              style: _headingStyle(context, widget.block.headingLevel),
            ),
          ),
        ],
      ),
      ContentBlockType.code => _CodeBlock(
        block: widget.block,
        textController: _textController,
        focusNode: _focusNode,
        onChanged: widget.onTextChanged,
        onLanguageChanged: (language) =>
            widget.onMetadataChanged({'language': language}),
      ),
      ContentBlockType.checklist => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            key: ValueKey('checklist-toggle-${widget.block.id.value}'),
            value: widget.block.isChecked,
            onChanged: (checked) =>
                widget.onMetadataChanged({'checked': checked ?? false}),
          ),
          Expanded(
            child: _textField(
              key: ValueKey('block-text-${widget.block.id.value}'),
              hint: 'Checklist item',
              minLines: 1,
              maxLines: null,
              border: InputBorder.none,
              style: widget.block.isChecked
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
          ),
        ],
      ),
      ContentBlockType.bulletList => _PrefixedTextBlock(
        prefix: '•',
        child: _textField(
          key: ValueKey('block-text-${widget.block.id.value}'),
          hint: 'One item per line',
          minLines: 1,
          maxLines: null,
          border: InputBorder.none,
        ),
      ),
      ContentBlockType.numberedList => _PrefixedTextBlock(
        prefix: '1.',
        child: _textField(
          key: ValueKey('block-text-${widget.block.id.value}'),
          hint: 'One item per line',
          minLines: 1,
          maxLines: null,
          border: InputBorder.none,
        ),
      ),
      ContentBlockType.quote => Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 3,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        padding: const EdgeInsets.only(left: 12),
        child: _textField(
          key: ValueKey('block-text-${widget.block.id.value}'),
          hint: 'Quote',
          minLines: 1,
          maxLines: null,
          border: InputBorder.none,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      ContentBlockType.divider => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Divider(),
      ),
    };
  }

  Widget _textField({
    required Key key,
    required String hint,
    required int minLines,
    required int? maxLines,
    required InputBorder border,
    TextStyle? style,
  }) {
    return TextField(
      key: key,
      controller: _textController,
      focusNode: _focusNode,
      minLines: minLines,
      maxLines: maxLines,
      style: style,
      decoration: InputDecoration(hintText: hint, border: border),
      onChanged: widget.onTextChanged,
    );
  }

  void _insertIndent() {
    final value = _textController.value;
    final selection = value.selection;
    final start = selection.isValid ? selection.start : value.text.length;
    final end = selection.isValid ? selection.end : value.text.length;
    const indent = '  ';
    final text = value.text.replaceRange(start, end, indent);
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + indent.length),
    );
    widget.onTextChanged(text);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({
    required this.block,
    required this.textController,
    required this.focusNode,
    required this.onChanged,
    required this.onLanguageChanged,
  });

  final ContentBlock block;
  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onLanguageChanged;

  static const languages = <String, String>{
    'plainText': 'Plain Text',
    'dart': 'Dart',
    'csharp': 'C#',
    'python': 'Python',
    'javascript': 'JavaScript',
    'typescript': 'TypeScript',
    'json': 'JSON',
    'sql': 'SQL',
    'html': 'HTML',
    'css': 'CSS',
    'bash': 'Bash',
    'powershell': 'PowerShell',
  };

  @override
  Widget build(BuildContext context) {
    final selected = languages.containsKey(block.codeLanguage)
        ? block.codeLanguage
        : 'plainText';
    return Material(
      key: ValueKey('code-block-${block.id.value}'),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  key: ValueKey('code-language-${block.id.value}'),
                  value: selected,
                  items: [
                    for (final entry in languages.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                  ],
                  onChanged: (language) {
                    if (language != null) onLanguageChanged(language);
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  key: ValueKey('copy-code-${block.id.value}'),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: block.text));
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Copied'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy'),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1200,
                child: TextField(
                  key: ValueKey('block-text-${block.id.value}'),
                  controller: textController,
                  focusNode: focusNode,
                  minLines: 3,
                  maxLines: null,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontFamilyFallback: ['Consolas', 'Courier New'],
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter code…',
                    border: InputBorder.none,
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrefixedTextBlock extends StatelessWidget {
  const _PrefixedTextBlock({required this.prefix, required this.child});

  final String prefix;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, right: 8),
          child: Text(prefix),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _BlockActions extends StatelessWidget {
  const _BlockActions({
    required this.block,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onChangeType,
    required this.onMove,
    required this.onDelete,
  });

  final ContentBlock block;
  final bool canMoveUp;
  final bool canMoveDown;
  final Future<void> Function(ContentBlockType type) onChangeType;
  final Future<void> Function(int delta) onMove;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<ContentBlockType>(
          tooltip: 'Change block type',
          onSelected: (type) => unawaited(onChangeType(type)),
          itemBuilder: (_) => [
            for (final type in ContentBlockType.values)
              PopupMenuItem(value: type, child: Text(_typeLabel(type))),
          ],
          icon: const Icon(Icons.swap_horiz, size: 18),
        ),
        PopupMenuButton<String>(
          tooltip: 'Block actions',
          onSelected: (action) {
            switch (action) {
              case 'up':
                unawaited(onMove(-1));
              case 'down':
                unawaited(onMove(1));
              case 'delete':
                unawaited(onDelete());
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'up',
              enabled: canMoveUp,
              child: const Text('Move Up'),
            ),
            PopupMenuItem(
              value: 'down',
              enabled: canMoveDown,
              child: const Text('Move Down'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(value: 'delete', child: Text('Delete Block')),
          ],
        ),
      ],
    );
  }
}

TextStyle? _headingStyle(BuildContext context, int level) {
  return switch (level) {
    1 => Theme.of(context).textTheme.headlineMedium,
    2 => Theme.of(context).textTheme.headlineSmall,
    _ => Theme.of(context).textTheme.titleLarge,
  };
}

String _typeLabel(ContentBlockType type) => switch (type) {
  ContentBlockType.paragraph => 'Paragraph',
  ContentBlockType.heading => 'Heading',
  ContentBlockType.code => 'Code',
  ContentBlockType.checklist => 'Checklist',
  ContentBlockType.bulletList => 'Bulleted List',
  ContentBlockType.numberedList => 'Numbered List',
  ContentBlockType.quote => 'Quote',
  ContentBlockType.divider => 'Divider',
};
