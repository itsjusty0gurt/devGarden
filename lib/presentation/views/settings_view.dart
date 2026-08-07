import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/preferences/shell_preferences.dart';
import '../shell/shell_controller.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shellControllerProvider);
    final controller = ref.read(shellControllerProvider.notifier);

    return SingleChildScrollView(
      key: const Key('settings-view'),
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              _SettingsSection(
                title: 'Appearance',
                description: 'Choose how devGarden follows the Windows theme.',
                child: SegmentedButton<ThemeMode>(
                  key: const Key('appearance-selector'),
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                    ),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                  ],
                  selected: {state.appearanceMode},
                  onSelectionChanged: (selection) {
                    unawaited(controller.setAppearanceMode(selection.single));
                  },
                ),
              ),
              const SizedBox(height: 28),
              _SettingsSection(
                title: 'Project Explorer',
                description:
                    'Place the desktop Project Explorer on either side.',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SegmentedButton<ExplorerSide>(
                      key: const Key('explorer-side-selector'),
                      segments: const [
                        ButtonSegment(
                          value: ExplorerSide.left,
                          icon: Icon(Icons.align_horizontal_left),
                          label: Text('Left'),
                        ),
                        ButtonSegment(
                          value: ExplorerSide.right,
                          icon: Icon(Icons.align_horizontal_right),
                          label: Text('Right'),
                        ),
                      ],
                      selected: {state.explorerSide},
                      onSelectionChanged: (selection) {
                        unawaited(controller.setExplorerSide(selection.single));
                      },
                    ),
                    OutlinedButton.icon(
                      key: const Key('reset-explorer-width'),
                      onPressed: () =>
                          unawaited(controller.resetExplorerWidth()),
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reset width'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
