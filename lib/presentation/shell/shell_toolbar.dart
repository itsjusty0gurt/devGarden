import 'package:flutter/material.dart';

class ShellToolbar extends StatelessWidget {
  const ShellToolbar({
    required this.explorerHidden,
    required this.onToggleExplorer,
    required this.onNew,
    required this.onSave,
    required this.onUndo,
    required this.onRedo,
    required this.onSearch,
    required this.onZoomOut,
    required this.onZoomIn,
    required this.zoomLabel,
    super.key,
  });

  final bool explorerHidden;
  final VoidCallback onToggleExplorer;
  final VoidCallback onNew;
  final VoidCallback onSave;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback onSearch;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;
  final String zoomLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('toolbar-region'),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: SizedBox(
        height: 44,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 4),
              _button(
                tooltip: explorerHidden
                    ? 'Show Project Explorer'
                    : 'Hide Project Explorer',
                icon: Icons.view_sidebar_outlined,
                onPressed: onToggleExplorer,
              ),
              const VerticalDivider(indent: 8, endIndent: 8),
              _button(tooltip: 'New…', icon: Icons.add, onPressed: onNew),
              _button(
                tooltip: 'Save',
                icon: Icons.save_outlined,
                onPressed: onSave,
              ),
              _button(
                tooltip: 'Undo unavailable',
                icon: Icons.undo,
                onPressed: onUndo,
              ),
              _button(
                tooltip: 'Redo unavailable',
                icon: Icons.redo,
                onPressed: onRedo,
              ),
              const VerticalDivider(indent: 8, endIndent: 8),
              _button(
                tooltip: 'Search',
                icon: Icons.search,
                onPressed: onSearch,
              ),
              const VerticalDivider(indent: 8, endIndent: 8),
              _button(
                tooltip: 'Zoom out',
                icon: Icons.zoom_out,
                onPressed: onZoomOut,
              ),
              Semantics(
                label: 'Current content zoom $zoomLabel',
                child: SizedBox(
                  width: 52,
                  child: Text(
                    zoomLabel,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              _button(
                tooltip: 'Zoom in',
                icon: Icons.zoom_in,
                onPressed: onZoomIn,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button({
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
    );
  }
}
