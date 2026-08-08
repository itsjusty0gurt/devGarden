import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/preferences/shell_preferences.dart';
import '../garden/content_block_controller.dart';
import '../garden/hierarchy_controller.dart';
import '../garden/idea_controller.dart';
import '../garden/idea_group_controller.dart';
import 'project_explorer.dart';
import 'shell_controller.dart';
import 'shell_menu_bar.dart';
import 'shell_status_bar.dart';
import 'shell_toolbar.dart';

class DesktopShell extends ConsumerStatefulWidget {
  const DesktopShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends ConsumerState<DesktopShell> {
  bool _explorerTemporarilyHidden = false;

  ShellController get _controller => ref.read(shellControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final shellState = ref.watch(shellControllerProvider);
    final ideaState = ref.watch(ideaControllerProvider);
    final blockState = ref.watch(contentBlockControllerProvider);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.comma, control: true): () =>
            context.go('/settings'),
        const SingleActivator(
          LogicalKeyboardKey.keyP,
          control: true,
          shift: true,
        ): () =>
            unawaited(_showCommandPalette()),
        const SingleActivator(LogicalKeyboardKey.keyP, control: true): () =>
            unawaited(_showQuickOpen()),
        const SingleActivator(
          LogicalKeyboardKey.keyF,
          control: true,
          shift: true,
        ): () =>
            unawaited(_showFindInProject()),
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
            unawaited(_save()),
        const SingleActivator(LogicalKeyboardKey.escape): _closeTransient,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                ShellMenuBar(actions: _menuActions()),
                const Divider(height: 1),
                ShellToolbar(
                  explorerHidden: _explorerTemporarilyHidden,
                  onToggleExplorer: () {
                    setState(() {
                      _explorerTemporarilyHidden = !_explorerTemporarilyHidden;
                    });
                  },
                  onNew: () => unawaited(_newIdea()),
                  onSave: () => unawaited(_save()),
                  onUndo: null,
                  onRedo: null,
                  onSearch: () => context.go('/app'),
                  onZoomOut: () =>
                      _controller.fireAndForget(_controller.changeZoom(-0.1)),
                  onZoomIn: () =>
                      _controller.fireAndForget(_controller.changeZoom(0.1)),
                  zoomLabel: ShellController.displayZoom(
                    shellState.contentZoom,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _buildWorkspace(
                        context,
                        shellState,
                        showExplorer: !_explorerTemporarilyHidden,
                        useExplorerOverlay: constraints.maxWidth < 720,
                        availableWidth: constraints.maxWidth,
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ShellStatusBar(
                  message:
                      blockState.statusMessage ??
                      ideaState.statusMessage ??
                      shellState.statusMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspace(
    BuildContext context,
    ShellState state, {
    required bool showExplorer,
    required bool useExplorerOverlay,
    required double availableWidth,
  }) {
    final maxWidth = (availableWidth * 0.42).clamp(180, 420).toDouble();
    final explorerWidth = state.explorerWidth.clamp(180, maxWidth).toDouble();
    final workArea = MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(state.contentZoom)),
      child: KeyedSubtree(
        key: const Key('work-area-region'),
        child: widget.child,
      ),
    );

    if (!showExplorer) {
      return workArea;
    }

    final explorer = SizedBox(
      key: const Key('project-explorer-region'),
      width: explorerWidth,
      child: const ProjectExplorer(),
    );

    if (useExplorerOverlay) {
      final overlayWidth = availableWidth >= 240
          ? explorerWidth.clamp(180, availableWidth * 0.78).toDouble()
          : availableWidth;
      return Stack(
        children: [
          Positioned.fill(child: workArea),
          Positioned(
            top: 0,
            bottom: 0,
            left: state.explorerSide == ExplorerSide.left ? 0 : null,
            right: state.explorerSide == ExplorerSide.right ? 0 : null,
            width: overlayWidth,
            child: Material(elevation: 8, child: explorer),
          ),
        ],
      );
    }

    final content = Expanded(child: workArea);
    final divider = _ResizableDivider(
      onDrag: (delta) {
        final signedDelta = state.explorerSide == ExplorerSide.left
            ? delta
            : -delta;
        _controller.setExplorerWidth(explorerWidth + signedDelta);
      },
      onDragEnd: () =>
          _controller.fireAndForget(_controller.persistExplorerWidth()),
    );

    return Row(
      children: state.explorerSide == ExplorerSide.left
          ? [explorer, divider, content]
          : [content, divider, explorer],
    );
  }

  ShellMenuActions _menuActions() {
    return ShellMenuActions(
      placeholder: _controller.placeholder,
      newIdea: () => unawaited(_newIdea()),
      save: () => unawaited(_save()),
      openSettings: () => context.go('/settings'),
      commandPalette: () => unawaited(_showCommandPalette()),
      quickOpen: () => unawaited(_showQuickOpen()),
      findInProject: () => unawaited(_showFindInProject()),
      showGettingStarted: () => context.go('/'),
      showAbout: () => unawaited(_showAbout()),
      exit: SystemNavigator.pop,
    );
  }

  Future<void> _showCommandPalette() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Command Palette'),
        children: [
          _command(
            dialogContext,
            'Open Settings',
            () => context.go('/settings'),
          ),
          _command(dialogContext, 'Explorer: Move Left', () {
            _controller.fireAndForget(
              _controller.setExplorerSide(ExplorerSide.left),
            );
          }),
          _command(dialogContext, 'Explorer: Move Right', () {
            _controller.fireAndForget(
              _controller.setExplorerSide(ExplorerSide.right),
            );
          }),
          for (final mode in ThemeMode.values)
            _command(
              dialogContext,
              'Appearance: ${_themeModeLabel(mode)}',
              () => _controller.fireAndForget(
                _controller.setAppearanceMode(mode),
              ),
            ),
        ],
      ),
    );
  }

  Widget _command(
    BuildContext dialogContext,
    String label,
    VoidCallback action,
  ) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.of(dialogContext).pop();
        action();
      },
      child: Text(label),
    );
  }

  Future<void> _showQuickOpen() => _showMessageDialog(
    title: 'Quick Open',
    message: 'Quick Open is deferred beyond the current Idea slice.',
  );

  Future<void> _showFindInProject() => _showMessageDialog(
    title: 'Find in Project',
    message:
        'Use the Ideas search field for title and block-content search in the current App.',
  );

  Future<void> _showAbout() => _showMessageDialog(
    title: 'About devGarden',
    message: 'devGarden\nWhere ideas grow!\n\nLocal capture-first Ideas.',
  );

  Future<void> _showMessageDialog({
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _closeTransient() {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<void> _newIdea() async {
    if (ref.read(selectedAppIdProvider) == null) {
      _controller.setStatus('Create or select an App before adding an Idea.');
      return;
    }
    try {
      await Future.wait([
        ref.read(ideaControllerProvider.notifier).flush(),
        ref.read(contentBlockControllerProvider.notifier).flush(),
      ]);
      final idea = await ref.read(ideaControllerProvider.notifier).capture();
      ref.read(ideaGroupControllerProvider.notifier).showUngrouped();
      if (mounted) context.go('/idea/${idea.id.value}');
    } catch (_) {
      _controller.setStatus('Idea creation failed.');
    }
  }

  Future<void> _save() async {
    final ideas = ref.read(ideaControllerProvider);
    final isEditingIdea = GoRouterState.of(
      context,
    ).uri.path.startsWith('/idea/');
    if (!isEditingIdea || ideas.current == null) {
      _controller.saveUnavailable();
      return;
    }
    await Future.wait([
      ref.read(ideaControllerProvider.notifier).flush(),
      ref.read(contentBlockControllerProvider.notifier).flush(),
    ]);
  }

  String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };
  }
}

class _ResizableDivider extends StatelessWidget {
  const _ResizableDivider({required this.onDrag, required this.onDragEnd});

  final ValueChanged<double> onDrag;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        key: const Key('explorer-divider'),
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
        onHorizontalDragEnd: (_) => onDragEnd(),
        child: SizedBox(
          width: 6,
          child: Center(
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
      ),
    );
  }
}
