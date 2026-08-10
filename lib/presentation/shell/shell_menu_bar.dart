import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShellMenuActions {
  const ShellMenuActions({
    required this.placeholder,
    required this.newIdea,
    required this.save,
    required this.undo,
    required this.redo,
    required this.canUndo,
    required this.canRedo,
    required this.openSettings,
    required this.commandPalette,
    required this.quickOpen,
    required this.findInProject,
    required this.showGettingStarted,
    required this.showAbout,
    required this.exit,
  });

  final ValueChanged<String> placeholder;
  final VoidCallback newIdea;
  final VoidCallback save;
  final VoidCallback undo;
  final VoidCallback redo;
  final bool canUndo;
  final bool canRedo;
  final VoidCallback openSettings;
  final VoidCallback commandPalette;
  final VoidCallback quickOpen;
  final VoidCallback findInProject;
  final VoidCallback showGettingStarted;
  final VoidCallback showAbout;
  final VoidCallback exit;
}

class ShellMenuBar extends StatelessWidget {
  const ShellMenuBar({required this.actions, super.key});

  final ShellMenuActions actions;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('menu-bar-region'),
      color: Theme.of(context).colorScheme.surface,
      child: Align(
        alignment: Alignment.centerLeft,
        child: MenuBar(
          children: [
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: actions.newIdea,
                  child: const Text('New Idea'),
                ),
                _placeholder('Open'),
                MenuItemButton(
                  onPressed: actions.save,
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyS,
                    control: true,
                  ),
                  child: const Text('Save'),
                ),
                _placeholder('Save All'),
                const Divider(),
                _placeholder('Import'),
                _placeholder('Export'),
                const Divider(),
                MenuItemButton(
                  onPressed: actions.openSettings,
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.comma,
                    control: true,
                  ),
                  child: const Text('Settings'),
                ),
                const Divider(),
                MenuItemButton(
                  onPressed: actions.exit,
                  child: const Text('Exit'),
                ),
              ],
              child: const Text('File'),
            ),
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: actions.canUndo ? actions.undo : null,
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyZ,
                    control: true,
                  ),
                  child: const Text('Undo'),
                ),
                MenuItemButton(
                  onPressed: actions.canRedo ? actions.redo : null,
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyY,
                    control: true,
                  ),
                  child: const Text('Redo'),
                ),
                const Divider(),
                const MenuItemButton(onPressed: null, child: Text('Cut')),
                const MenuItemButton(onPressed: null, child: Text('Copy')),
                const MenuItemButton(onPressed: null, child: Text('Paste')),
                const MenuItemButton(
                  onPressed: null,
                  child: Text('Select All'),
                ),
                const Divider(),
                MenuItemButton(
                  onPressed: actions.quickOpen,
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyP,
                    control: true,
                  ),
                  child: const Text('Find'),
                ),
                MenuItemButton(
                  onPressed: actions.findInProject,
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyF,
                    control: true,
                    shift: true,
                  ),
                  child: const Text('Find in Project'),
                ),
              ],
              child: const Text('Edit'),
            ),
            SubmenuButton(
              menuChildren: [
                for (final label in const [
                  'New Workspace',
                  'New Project',
                  'New App',
                  'New Idea Group',
                ])
                  _placeholder(label),
                MenuItemButton(
                  onPressed: actions.newIdea,
                  child: const Text('New Idea'),
                ),
              ],
              child: const Text('Projects'),
            ),
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: actions.commandPalette,
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyP,
                    control: true,
                    shift: true,
                  ),
                  child: const Text('Command Palette'),
                ),
                _placeholder('Keyboard Shortcuts'),
              ],
              child: const Text('Tools'),
            ),
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: actions.showGettingStarted,
                  child: const Text('Getting Started'),
                ),
                _placeholder('Documentation'),
                MenuItemButton(
                  onPressed: actions.showAbout,
                  child: const Text('About devGarden'),
                ),
              ],
              child: const Text('Help'),
            ),
          ],
        ),
      ),
    );
  }

  MenuItemButton _placeholder(String label) {
    return MenuItemButton(
      onPressed: () => actions.placeholder(label),
      child: Text(label),
    );
  }
}
