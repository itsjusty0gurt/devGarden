import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ExplorerNodeType {
  workspace,
  project,
  app,
  ideaGroup,
  ungrouped,
  idea,
  action,
}

class ExplorerNode {
  const ExplorerNode({
    required this.key,
    required this.type,
    required this.title,
    required this.icon,
    this.children = const [],
    this.selected = false,
    this.onActivate,
    this.trailing,
  });

  final String key;
  final ExplorerNodeType type;
  final String title;
  final IconData icon;
  final List<ExplorerNode> children;
  final bool selected;
  final FutureOr<void> Function()? onActivate;
  final Widget? trailing;

  bool get isExpandable =>
      children.isNotEmpty ||
      {
        ExplorerNodeType.workspace,
        ExplorerNodeType.project,
        ExplorerNodeType.app,
        ExplorerNodeType.ideaGroup,
        ExplorerNodeType.ungrouped,
      }.contains(type);

  String get expandLabel => switch (type) {
    ExplorerNodeType.workspace => 'Expand Workspace $title',
    ExplorerNodeType.project => 'Expand Project $title',
    ExplorerNodeType.app => 'Expand App $title',
    ExplorerNodeType.ideaGroup => 'Expand Idea Group $title',
    ExplorerNodeType.ungrouped => 'Expand Ungrouped Ideas',
    _ => 'Expand $title',
  };

  String get collapseLabel => expandLabel.replaceFirst('Expand', 'Collapse');
}

class ExplorerTree extends StatefulWidget {
  const ExplorerTree({required this.nodes, super.key});

  final List<ExplorerNode> nodes;

  @override
  State<ExplorerTree> createState() => _ExplorerTreeState();
}

class _ExplorerTreeState extends State<ExplorerTree> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'Project Explorer tree');
  final Map<String, bool> _expanded = {};
  int _focusedRow = 0;

  @override
  Widget build(BuildContext context) {
    final rows = <_ExplorerRow>[];
    for (var index = 0; index < widget.nodes.length; index++) {
      _flatten(
        widget.nodes[index],
        rows,
        depth: 0,
        isLast: index == widget.nodes.length - 1,
        ancestorContinuations: const [],
      );
    }
    if (rows.isNotEmpty) _focusedRow = _focusedRow.clamp(0, rows.length - 1);
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (_, event) => _handleKey(event, rows),
      child: ListView.builder(
        key: const Key('explorer-tree'),
        itemCount: rows.length,
        itemBuilder: (context, index) => _row(
          context,
          rows[index],
          index,
          keyboardFocused: _focusNode.hasFocus && _focusedRow == index,
        ),
      ),
    );
  }

  void _flatten(
    ExplorerNode node,
    List<_ExplorerRow> rows, {
    required int depth,
    required bool isLast,
    required List<bool> ancestorContinuations,
  }) {
    rows.add(
      _ExplorerRow(
        node: node,
        depth: depth,
        isLast: isLast,
        ancestorContinuations: ancestorContinuations,
      ),
    );
    if (!node.isExpandable || !(_expanded[node.key] ?? true)) return;
    for (var index = 0; index < node.children.length; index++) {
      _flatten(
        node.children[index],
        rows,
        depth: depth + 1,
        isLast: index == node.children.length - 1,
        ancestorContinuations: [...ancestorContinuations, !isLast],
      );
    }
  }

  Widget _row(
    BuildContext context,
    _ExplorerRow row,
    int index, {
    required bool keyboardFocused,
  }) {
    final node = row.node;
    final expanded = _expanded[node.key] ?? true;
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      key: ValueKey(node.key),
      button: true,
      selected: node.selected,
      expanded: node.isExpandable ? expanded : null,
      label: node.type == ExplorerNodeType.idea
          ? 'Open Idea ${node.title}'
          : node.type == ExplorerNodeType.ungrouped
          ? 'Ungrouped Ideas'
          : node.title,
      child: InkWell(
        onHover: (_) => setState(() {}),
        onTap: () {
          _focusNode.requestFocus();
          setState(() => _focusedRow = index);
          _activate(row);
        },
        child: Container(
          height: 34,
          color: node.selected
              ? colors.secondaryContainer.withValues(alpha: 0.55)
              : keyboardFocused
              ? colors.surfaceContainerHighest
              : null,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: _ConnectorPainter(
                      depth: row.depth,
                      isLast: row.isLast,
                      ancestorContinuations: row.ancestorContinuations,
                      color: colors.outlineVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: row.depth * 18.0 + 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: node.isExpandable
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 24,
                                height: 30,
                              ),
                              tooltip: expanded
                                  ? node.collapseLabel
                                  : node.expandLabel,
                              onPressed: () => _toggle(node),
                              icon: Icon(
                                expanded
                                    ? Icons.expand_more
                                    : Icons.chevron_right,
                                size: 18,
                              ),
                            )
                          : null,
                    ),
                    Icon(node.icon, size: 17),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        node.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ?node.trailing,
                    const SizedBox(width: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKey(KeyEvent event, List<_ExplorerRow> rows) {
    if (event is! KeyDownEvent || rows.isEmpty) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() => _focusedRow = (_focusedRow - 1).clamp(0, rows.length - 1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() => _focusedRow = (_focusedRow + 1).clamp(0, rows.length - 1));
      return KeyEventResult.handled;
    }
    final node = rows[_focusedRow].node;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && node.isExpandable) {
      if (_expanded[node.key] ?? true) _toggle(node);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        node.isExpandable) {
      if (!(_expanded[node.key] ?? true)) _toggle(node);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _activate(rows[_focusedRow]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _activate(_ExplorerRow row) {
    final node = row.node;
    if (node.onActivate != null) {
      unawaited(Future.sync(node.onActivate!));
    } else if (node.isExpandable) {
      _toggle(node);
    }
  }

  void _toggle(ExplorerNode node) {
    setState(() => _expanded[node.key] = !(_expanded[node.key] ?? true));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

class _ExplorerRow {
  const _ExplorerRow({
    required this.node,
    required this.depth,
    required this.isLast,
    required this.ancestorContinuations,
  });

  final ExplorerNode node;
  final int depth;
  final bool isLast;
  final List<bool> ancestorContinuations;
}

class _ConnectorPainter extends CustomPainter {
  const _ConnectorPainter({
    required this.depth,
    required this.isLast,
    required this.ancestorContinuations,
    required this.color,
  });

  final int depth;
  final bool isLast;
  final List<bool> ancestorContinuations;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (depth == 0) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const slot = 18.0;
    final middle = size.height / 2;
    for (var index = 0; index < ancestorContinuations.length; index++) {
      if (ancestorContinuations[index]) {
        final x = index * slot + 13;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    }
    final x = (depth - 1) * slot + 13;
    canvas.drawLine(Offset(x, 0), Offset(x, middle), paint);
    if (!isLast) {
      canvas.drawLine(Offset(x, middle), Offset(x, size.height), paint);
    }
    canvas.drawLine(Offset(x, middle), Offset(depth * slot + 4, middle), paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter oldDelegate) =>
      depth != oldDelegate.depth ||
      isLast != oldDelegate.isLast ||
      ancestorContinuations != oldDelegate.ancestorContinuations ||
      color != oldDelegate.color;
}
