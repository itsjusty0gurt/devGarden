import 'package:dev_garden/app/app.dart';
import 'package:dev_garden/app/providers.dart';
import 'package:dev_garden/core/preferences/shell_preferences.dart';
import 'package:dev_garden/infrastructure/database/app_database.dart';
import 'package:dev_garden/presentation/garden/idea_controller.dart';
import 'package:dev_garden/presentation/shell/desktop_shell.dart';
import 'package:dev_garden/presentation/shell/shell_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'empty database supports capture, save, search, reopen, and soft delete',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await _pumpProduct(tester, database);

      await tester.tap(find.byKey(const Key('empty-create-workspace-button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('workspace-name-field')),
        'My Workspace',
      );
      await tester.tap(find.byKey(const Key('confirm-name-button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Project'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('project-name-field')),
        'My Project',
      );
      await tester.tap(find.byKey(const Key('confirm-name-button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create App'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('app-name-field')), 'My App');
      await tester.tap(find.byKey(const Key('confirm-name-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('ideas-view')), findsOneWidget);
      await tester.tap(find.byKey(const Key('create-idea-group')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('idea-group-name-field')),
        'Research',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();
      expect(find.text('Research'), findsOneWidget);

      await tester.tap(find.byKey(const Key('new-idea-button')));
      await tester.pumpAndSettle();

      final bodyField = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('idea-body-field')),
          matching: find.byType(EditableText),
        ),
      );
      expect(bodyField.focusNode.hasFocus, isTrue);

      await tester.enterText(
        find.byKey(const Key('idea-title-field')),
        'Persistent Idea',
      );
      await tester.enterText(
        find.byKey(const Key('idea-body-field')),
        'Recognizable persistence text',
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(DesktopShell)),
      );
      final capturedId = container.read(ideaControllerProvider).current!.id;
      final persisted = await container
          .read(ideaRepositoryProvider)
          .getById(capturedId);
      expect(persisted?.body, 'Recognizable persistence text');
      expect(persisted?.groupId, isNull);

      await tester.tap(find.byTooltip('Back to Ideas'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Move Persistent Idea'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Research').last);
      await tester.pumpAndSettle();
      expect(
        (await container.read(ideaRepositoryProvider).getById(capturedId))
            ?.groupId,
        isNotNull,
      );
      await tester.enterText(
        find.byKey(const Key('idea-search-field')),
        'persistence text',
      );
      await tester.pumpAndSettle();
      expect(find.text('Persistent Idea'), findsOneWidget);

      await tester.tap(find.text('Persistent Idea'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('idea-body-field')))
            .controller
            ?.text,
        'Recognizable persistence text',
      );

      await tester.tap(find.byTooltip('Archive Idea'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Archive'));
      await tester.pumpAndSettle();

      expect(find.text('No matching Ideas.'), findsOneWidget);
      final retained = await container
          .read(ideaRepositoryProvider)
          .getById(capturedId);
      expect(retained?.isDeleted, isTrue);
    },
  );
}

Future<void> _pumpProduct(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        shellPreferencesStoreProvider.overrideWithValue(
          MemoryShellPreferencesStore(),
        ),
        initialShellPreferencesProvider.overrideWithValue(
          ShellPreferences.defaults,
        ),
        databaseProvider.overrideWithValue(database),
      ],
      child: const GardenApplication(),
    ),
  );
  await tester.pumpAndSettle();
}
