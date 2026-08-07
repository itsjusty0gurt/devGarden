import 'package:dev_garden/app/app.dart';
import 'package:dev_garden/core/preferences/shell_preferences.dart';
import 'package:dev_garden/presentation/shell/desktop_shell.dart';
import 'package:dev_garden/presentation/shell/shell_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('app launches with all top-level desktop shell regions', (
    tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text('devGarden'), findsOneWidget);
    expect(find.text('Where ideas grow!'), findsOneWidget);
    expect(find.byKey(const Key('menu-bar-region')), findsOneWidget);
    expect(find.byKey(const Key('toolbar-region')), findsOneWidget);
    expect(find.byKey(const Key('project-explorer-region')), findsOneWidget);
    expect(find.byKey(const Key('explorer-divider')), findsOneWidget);
    expect(find.byKey(const Key('work-area-region')), findsOneWidget);
    expect(find.byKey(const Key('status-bar-region')), findsOneWidget);
    expect(find.text('Layout preview — no saved project data'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);
  });

  testWidgets('restored Explorer side controls shell placement', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      initialPreferences: ShellPreferences.defaults.copyWith(
        explorerSide: ExplorerSide.right,
      ),
    );

    final explorerPosition = tester.getTopLeft(
      find.byKey(const Key('project-explorer-region')),
    );
    final workAreaPosition = tester.getTopLeft(
      find.byKey(const Key('work-area-region')),
    );

    expect(explorerPosition.dx, greaterThan(workAreaPosition.dx));
  });

  testWidgets('Explorer can switch sides and persists the selection', (
    tester,
  ) async {
    final store = MemoryShellPreferencesStore();
    await _pumpApp(tester, store: store);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(DesktopShell)),
    );

    await container
        .read(shellControllerProvider.notifier)
        .setExplorerSide(ExplorerSide.right);
    await tester.pump();

    final explorerPosition = tester.getTopLeft(
      find.byKey(const Key('project-explorer-region')),
    );
    final workAreaPosition = tester.getTopLeft(
      find.byKey(const Key('work-area-region')),
    );
    expect(explorerPosition.dx, greaterThan(workAreaPosition.dx));
    expect(store.value.explorerSide, ExplorerSide.right);
  });

  testWidgets('narrow layout keeps Explorer recoverable as an overlay', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(600, 600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await _pumpApp(tester);

    expect(find.byKey(const Key('work-area-region')), findsOneWidget);
    expect(find.byKey(const Key('project-explorer-region')), findsOneWidget);

    await tester.tap(find.byTooltip('Hide Project Explorer'));
    await tester.pump();
    expect(find.byKey(const Key('project-explorer-region')), findsNothing);
    expect(find.byKey(const Key('work-area-region')), findsOneWidget);

    await tester.tap(find.byTooltip('Show Project Explorer'));
    await tester.pump();
    expect(find.byKey(const Key('project-explorer-region')), findsOneWidget);
  });

  testWidgets('settings route is reachable and changes appearance', (
    tester,
  ) async {
    final store = MemoryShellPreferencesStore();
    await _pumpApp(tester, store: store);
    final context = tester.element(find.byType(DesktopShell));

    GoRouter.of(context).go('/settings');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings-view')), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(DesktopShell)),
    );
    for (final mode in ThemeMode.values) {
      await container
          .read(shellControllerProvider.notifier)
          .setAppearanceMode(mode);
      await tester.pumpAndSettle();

      expect(container.read(shellControllerProvider).appearanceMode, mode);
      expect(store.value.appearanceMode, mode);
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        mode,
      );
    }
  });

  testWidgets('top-level placeholder routes render', (tester) async {
    await _pumpApp(tester);
    final context = tester.element(find.byType(DesktopShell));
    final router = GoRouter.of(context);

    for (final route in const {
      '/workspace': 'Workspace',
      '/project': 'Project',
      '/app': 'App',
    }.entries) {
      router.go(route.key);
      await tester.pumpAndSettle();
      expect(find.text(route.value), findsWidgets);
    }
  });

  testWidgets('safe Save placeholder reports that no document is open', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byTooltip('Save'));
    await tester.pump();

    expect(
      find.text('Save unavailable — no document is open.'),
      findsOneWidget,
    );
  });

  testWidgets('command palette shortcut opens safe shell commands', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    expect(find.text('Command Palette'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);
    expect(find.text('Explorer: Move Right'), findsOneWidget);
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  ShellPreferences initialPreferences = ShellPreferences.defaults,
  MemoryShellPreferencesStore? store,
}) async {
  final preferencesStore = store ?? MemoryShellPreferencesStore();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        shellPreferencesStoreProvider.overrideWithValue(preferencesStore),
        initialShellPreferencesProvider.overrideWithValue(initialPreferences),
      ],
      child: const GardenApplication(),
    ),
  );
  await tester.pumpAndSettle();
}
