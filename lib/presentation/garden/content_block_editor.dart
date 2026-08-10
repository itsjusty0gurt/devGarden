import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/services/content_block_service.dart';
import '../../domain/models/entities.dart';
import 'content_block_controller.dart';

class ContentBlockEditor extends ConsumerStatefulWidget {
  const ContentBlockEditor({
    required this.ideaId,
    this.embedded = false,
    this.autofocus = true,
    super.key,
  });

  final EntityId ideaId;
  final bool embedded;
  final bool autofocus;

  @override
  ConsumerState<ContentBlockEditor> createState() => _ContentBlockEditorState();
}

class _ContentBlockEditorState extends ConsumerState<ContentBlockEditor> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  @override
  void didUpdateWidget(covariant ContentBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ideaId != widget.ideaId ||
        (!oldWidget.autofocus && widget.autofocus)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _open());
    }
  }

  Future<void> _open() async {
    if (!mounted) return;
    final controller = ref.read(
      contentBlockControllerProvider(widget.ideaId).notifier,
    );
    await controller.openIdea(
      widget.ideaId,
      requestInitialFocus: widget.autofocus,
    );
    if (!mounted || !widget.autofocus) return;
    ref
        .read(contentBlockSessionCoordinatorProvider.notifier)
        .activate(widget.ideaId);
    controller.focusFirst();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contentBlockControllerProvider(widget.ideaId));
    final controller = ref.read(
      contentBlockControllerProvider(widget.ideaId).notifier,
    );
    final sessions = ref.read(contentBlockSessionCoordinatorProvider.notifier);
    if (state.ideaId != widget.ideaId || state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final blockList = ListView.builder(
      key: widget.embedded
          ? ValueKey('block-list-${widget.ideaId.value}')
          : const Key('block-list'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: widget.embedded,
      physics: widget.embedded ? const NeverScrollableScrollPhysics() : null,
      itemCount: state.blocks.length,
      itemBuilder: (context, index) {
        final block = state.blocks[index];
        return _BlockSurface(
          key: ValueKey('block-${block.id.value}'),
          block: block,
          index: index,
          blockCount: state.blocks.length,
          focusEpoch: state.activeBlockId == block.id ? state.focusEpoch : -1,
          isActive: state.activeBlockId == block.id,
          slashOptions: state.slashBlockId == block.id
              ? state.slashOptions
              : const [],
          slashSelection: state.slashSelection,
          onActivate: () {
            sessions.activate(widget.ideaId);
            controller.activate(block.id);
          },
          onTextChanged: (value) => controller.updateText(block.id, value),
          onMetadataChanged: (value) =>
              controller.updateMetadata(block.id, value),
          onChangeType: (type) => controller.changeType(block.id, type),
          onMove: (delta) => controller.move(block.id, delta),
          onDelete: () => controller.delete(block.id),
          onSplit: (offset) => controller.splitBlock(block.id, offset),
          onBackspace: () => controller.handleBackspace(block.id),
          onFocusPrevious: () => controller.focusRelative(block.id, -1),
          onFocusNext: () => controller.focusRelative(block.id, 1),
          onFocusFirst: controller.focusFirst,
          onFocusLast: controller.focusLast,
          onUndo: controller.undo,
          onRedo: controller.redo,
          onSlashMove: controller.moveSlashSelection,
          onSlashExecute: (option) =>
              controller.executeSlashCommand(block.id, option),
          onSlashDismiss: controller.dismissSlashMenu,
          onRestoreFocus: () => controller.requestFocus(block.id),
          onInsertParagraph: () =>
              controller.add(ContentBlockType.paragraph, afterId: block.id),
          onInsertCode: () =>
              controller.add(ContentBlockType.code, afterId: block.id),
        );
      },
    );
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
        if (widget.embedded) blockList else Expanded(child: blockList),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Semantics(
            label: 'Add block',
            button: true,
            child: PopupMenuButton<ContentBlockType>(
              key: const Key('add-block-button'),
              tooltip: 'Add block',
              onSelected: (type) =>
                  unawaited(controller.add(type, afterId: state.activeBlockId)),
              itemBuilder: (_) => [
                for (final type in ContentBlockType.values)
                  PopupMenuItem(value: type, child: Text(_typeLabel(type))),
              ],
              child: IgnorePointer(
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.add),
                  label: Text('Add Block'),
                ),
              ),
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
    required this.isActive,
    required this.slashOptions,
    required this.slashSelection,
    required this.onActivate,
    required this.onTextChanged,
    required this.onMetadataChanged,
    required this.onChangeType,
    required this.onMove,
    required this.onDelete,
    required this.onSplit,
    required this.onBackspace,
    required this.onFocusPrevious,
    required this.onFocusNext,
    required this.onFocusFirst,
    required this.onFocusLast,
    required this.onUndo,
    required this.onRedo,
    required this.onSlashMove,
    required this.onSlashExecute,
    required this.onSlashDismiss,
    required this.onRestoreFocus,
    required this.onInsertParagraph,
    required this.onInsertCode,
    super.key,
  });

  final ContentBlock block;
  final int index;
  final int blockCount;
  final int focusEpoch;
  final bool isActive;
  final List<BlockCommandOption> slashOptions;
  final int slashSelection;
  final VoidCallback onActivate;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<Map<String, Object?>> onMetadataChanged;
  final Future<void> Function(ContentBlockType type) onChangeType;
  final Future<void> Function(int delta) onMove;
  final Future<void> Function() onDelete;
  final Future<void> Function(int offset) onSplit;
  final Future<void> Function() onBackspace;
  final VoidCallback onFocusPrevious;
  final VoidCallback onFocusNext;
  final VoidCallback onFocusFirst;
  final VoidCallback onFocusLast;
  final Future<void> Function() onUndo;
  final Future<void> Function() onRedo;
  final ValueChanged<int> onSlashMove;
  final Future<void> Function(BlockCommandOption? option) onSlashExecute;
  final VoidCallback onSlashDismiss;
  final VoidCallback onRestoreFocus;
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
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyZ, control: true): () =>
            unawaited(widget.onUndo()),
        const SingleActivator(LogicalKeyboardKey.keyY, control: true): () =>
            unawaited(widget.onRedo()),
        const SingleActivator(
          LogicalKeyboardKey.keyZ,
          control: true,
          shift: true,
        ): () =>
            unawaited(widget.onRedo()),
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
        const SingleActivator(LogicalKeyboardKey.arrowUp, control: true):
            widget.onFocusPrevious,
        const SingleActivator(LogicalKeyboardKey.arrowDown, control: true):
            widget.onFocusNext,
        const SingleActivator(LogicalKeyboardKey.home, control: true):
            widget.onFocusFirst,
        const SingleActivator(LogicalKeyboardKey.end, control: true):
            widget.onFocusLast,
        if (widget.block.type == ContentBlockType.code)
          const SingleActivator(LogicalKeyboardKey.tab): _insertIndent,
      },
      child: Focus(
        onKeyEvent: _handleKeyEvent,
        child: AnimatedContainer(
          duration: Duration.zero,
          decoration: BoxDecoration(
            color: widget.isActive
                ? Theme.of(context).colorScheme.surfaceContainerLow
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _blockContent(context)),
                  const SizedBox(width: 2),
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
              if (widget.slashOptions.isNotEmpty)
                _SlashCommandMenu(
                  options: widget.slashOptions,
                  selection: widget.slashSelection,
                  onSelected: widget.onSlashExecute,
                ),
            ],
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.enter &&
        HardwareKeyboard.instance.isShiftPressed &&
        widget.block.type != ContentBlockType.divider) {
      _insertText('\n');
      return KeyEventResult.handled;
    }
    if (widget.slashOptions.isNotEmpty) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        widget.onSlashMove(-1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        widget.onSlashMove(1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onSlashDismiss();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        unawaited(widget.onSlashExecute(null));
        return KeyEventResult.handled;
      }
    }
    final selection = _textController.selection;
    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.isControlPressed &&
        {
          ContentBlockType.paragraph,
          ContentBlockType.heading,
          ContentBlockType.checklist,
          ContentBlockType.quote,
        }.contains(widget.block.type)) {
      unawaited(
        widget.onSplit(
          selection.isValid ? selection.start : widget.block.text.length,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        selection.isValid &&
        selection.isCollapsed &&
        selection.start == 0 &&
        widget.block.type != ContentBlockType.code) {
      unawaited(widget.onBackspace());
      return KeyEventResult.handled;
    }
    if (widget.block.type == ContentBlockType.divider &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      unawaited(widget.onInsertParagraph());
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
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
          Semantics(
            label: 'Heading level',
            container: true,
            explicitChildNodes: true,
            child: Tooltip(
              message: 'Heading level',
              child: DropdownButton<int>(
                key: ValueKey('heading-level-${widget.block.id.value}'),
                value: widget.block.headingLevel.clamp(1, 3),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('H1')),
                  DropdownMenuItem(value: 2, child: Text('H2')),
                  DropdownMenuItem(value: 3, child: Text('H3')),
                ],
                onChanged: (level) {
                  if (level != null) {
                    widget.onMetadataChanged({'level': level});
                    widget.onRestoreFocus();
                  }
                },
              ),
            ),
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
        onRestoreFocus: widget.onRestoreFocus,
      ),
      ContentBlockType.checklist => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            key: ValueKey('checklist-toggle-${widget.block.id.value}'),
            value: widget.block.isChecked,
            semanticLabel:
                'Checklist item: ${widget.block.text.isEmpty ? 'empty' : widget.block.text}',
            onChanged: (checked) {
              widget.onMetadataChanged({'checked': checked ?? false});
              widget.onRestoreFocus();
            },
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
      ContentBlockType.divider => Focus(
        focusNode: _focusNode,
        child: Semantics(
          label: 'Divider block',
          focusable: true,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
        ),
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
    _insertText('  ');
  }

  void _insertText(String insertedText) {
    final value = _textController.value;
    final selection = value.selection;
    final start = selection.isValid ? selection.start : value.text.length;
    final end = selection.isValid ? selection.end : value.text.length;
    final text = value.text.replaceRange(start, end, insertedText);
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + insertedText.length),
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
    required this.onRestoreFocus,
  });

  final ContentBlock block;
  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onRestoreFocus;

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
                Semantics(
                  label: 'Select code language',
                  container: true,
                  explicitChildNodes: true,
                  child: Tooltip(
                    message: 'Select code language',
                    child: DropdownButton<String>(
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
                        if (language != null) {
                          onLanguageChanged(language);
                          onRestoreFocus();
                        }
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Tooltip(
                  message: 'Copy code',
                  child: TextButton.icon(
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
                      onRestoreFocus();
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
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
    return Semantics(
      label: 'Block type and actions menu',
      button: true,
      container: true,
      explicitChildNodes: true,
      child: PopupMenuButton<_BlockMenuAction>(
        tooltip: 'Block actions',
        onSelected: (action) {
          if (action.type case final type?) {
            unawaited(onChangeType(type));
          } else {
            switch (action.name) {
              case 'up':
                unawaited(onMove(-1));
              case 'down':
                unawaited(onMove(1));
              case 'delete':
                unawaited(onDelete());
            }
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: const _BlockMenuAction('up'),
            enabled: canMoveUp,
            child: const Text('Move block up'),
          ),
          PopupMenuItem(
            value: const _BlockMenuAction('down'),
            enabled: canMoveDown,
            child: const Text('Move block down'),
          ),
          const PopupMenuDivider(),
          for (final type in ContentBlockType.values)
            PopupMenuItem(
              value: _BlockMenuAction('type', type),
              enabled: type != block.type,
              child: Text('Change to ${_typeLabel(type)}'),
            ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: _BlockMenuAction('delete'),
            child: Text('Delete block'),
          ),
        ],
        icon: const Icon(Icons.more_vert, size: 18),
      ),
    );
  }
}

class _BlockMenuAction {
  const _BlockMenuAction(this.name, [this.type]);

  final String name;
  final ContentBlockType? type;
}

class _SlashCommandMenu extends StatelessWidget {
  const _SlashCommandMenu({
    required this.options,
    required this.selection,
    required this.onSelected,
  });

  final List<BlockCommandOption> options;
  final int selection;
  final Future<void> Function(BlockCommandOption? option) onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Block command suggestions',
      container: true,
      child: Material(
        key: const Key('slash-command-menu'),
        elevation: 4,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return Semantics(
                selected: index == selection,
                button: true,
                label: '${option.label}, ${option.command}',
                child: InkWell(
                  key: ValueKey('slash-command-${option.command}'),
                  onTap: () => unawaited(onSelected(option)),
                  child: Container(
                    color: index == selection
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(option.label)),
                        Text(
                          option.command,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
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
