import 'package:dev_garden/app/app.dart';
import 'package:dev_garden/app/providers.dart';
import 'package:dev_garden/core/preferences/shell_preferences.dart';
import 'package:dev_garden/domain/models/entities.dart';
import 'package:dev_garden/infrastructure/database/app_database.dart';
import 'package:dev_garden/presentation/garden/content_block_controller.dart';
import 'package:dev_garden/presentation/garden/idea_controller.dart';
import 'package:dev_garden/presentation/shell/desktop_shell.dart';
import 'package:dev_garden/presentation/shell/shell_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('block editor supports capture, block types, save, and search', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await _pumpProduct(tester, database);
    await _createHierarchy(tester);

    await tester.tap(find.byKey(const Key('create-idea-group')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('idea-group-name-field')),
      'Research',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('new-idea-button')));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(DesktopShell)),
    );
    final ideaId = container.read(ideaControllerProvider).current!.id;
    var blockState = container.read(contentBlockControllerProvider);
    final paragraphId = blockState.blocks.single.id;
    final paragraphField = find.byKey(
      ValueKey('block-text-${paragraphId.value}'),
    );

    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: paragraphField,
              matching: find.byType(EditableText),
            ),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.enterText(
      find.byKey(const Key('idea-title-field')),
      'Block Idea',
    );
    await tester.enterText(paragraphField, 'Immediate paragraph text');

    for (final label in [
      'Heading',
      'Code',
      'Checklist',
      'Bulleted List',
      'Numbered List',
      'Quote',
      'Divider',
    ]) {
      await _addBlock(tester, label);
    }
    blockState = container.read(contentBlockControllerProvider);
    expect(
      blockState.blocks.map((block) => block.type).toSet(),
      ContentBlockType.values.toSet(),
    );

    final heading = blockState.blocks.firstWhere(
      (block) => block.type == ContentBlockType.heading,
    );
    await _showBlock(tester, heading.id);
    await tester.enterText(
      find.byKey(ValueKey('block-text-${heading.id.value}')),
      'Planning heading',
    );
    await tester.tap(find.byKey(ValueKey('heading-level-${heading.id.value}')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('H2').last);
    await tester.pumpAndSettle();

    final code = container
        .read(contentBlockControllerProvider)
        .blocks
        .firstWhere((block) => block.type == ContentBlockType.code);
    await _showBlock(tester, code.id);
    const exactCode = 'def grow():\n    return "idea"\n';
    await tester.enterText(
      find.byKey(ValueKey('block-text-${code.id.value}')),
      exactCode,
    );
    await tester.tap(find.byKey(ValueKey('code-language-${code.id.value}')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Python').last);
    await tester.pumpAndSettle();
    String? copiedText;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copiedText =
            (call.arguments as Map<Object?, Object?>)['text'] as String?;
      }
      return null;
    });
    await tester.tap(find.byKey(ValueKey('copy-code-${code.id.value}')));
    await tester.pump(const Duration(milliseconds: 100));
    expect(copiedText, exactCode);
    messenger.setMockMethodCallHandler(SystemChannels.platform, null);

    final checklist = container
        .read(contentBlockControllerProvider)
        .blocks
        .firstWhere((block) => block.type == ContentBlockType.checklist);
    await _showBlock(tester, checklist.id);
    await tester.enterText(
      find.byKey(ValueKey('block-text-${checklist.id.value}')),
      'Verify persistence',
    );
    await tester.tap(
      find.byKey(ValueKey('checklist-toggle-${checklist.id.value}')),
    );
    await tester.pumpAndSettle();

    final codeSurface = find.byKey(ValueKey('block-${code.id.value}'));
    await _showBlock(tester, code.id);
    await tester.tap(
      find.descendant(
        of: codeSurface,
        matching: find.byTooltip('Block actions'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Move Up').last);
    await tester.pumpAndSettle();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);

    final persistedBlocks = await container
        .read(contentBlockRepositoryProvider)
        .listActiveByIdea(ideaId);
    expect(
      persistedBlocks.firstWhere((block) => block.id == code.id).text,
      exactCode,
    );
    expect(
      persistedBlocks.firstWhere((block) => block.id == code.id).codeLanguage,
      'python',
    );
    expect(
      persistedBlocks.firstWhere((block) => block.id == checklist.id).isChecked,
      isTrue,
    );
    expect(
      (await container.read(ideaRepositoryProvider).getById(ideaId))?.groupId,
      isNull,
    );

    await tester.tap(find.byTooltip('Back to Ideas'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Move Block Idea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Research').last);
    await tester.pumpAndSettle();
    expect(
      (await container.read(ideaRepositoryProvider).getById(ideaId))?.groupId,
      isNotNull,
    );

    await tester.enterText(
      find.byKey(const Key('idea-search-field')),
      'return "idea"',
    );
    await tester.pumpAndSettle();
    expect(find.text('Block Idea'), findsOneWidget);
    await tester.tap(find.text('Block Idea'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(
            find.byKey(ValueKey('block-text-${code.id.value}')),
          )
          .controller
          ?.text,
      exactCode,
    );
  });
}

Future<void> _showBlock(WidgetTester tester, EntityId id) async {
  final target = find.byKey(ValueKey('block-${id.value}'));
  if (target.evaluate().isEmpty) {
    await tester.drag(
      find.byKey(const Key('block-list')),
      const Offset(0, 10000),
    );
    await tester.pumpAndSettle();
  }
  if (target.evaluate().isEmpty) {
    await tester.dragUntilVisible(
      target,
      find.byKey(const Key('block-list')),
      const Offset(0, -240),
    );
  }
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
}

Future<void> _addBlock(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.byKey(const Key('add-block-button')));
  await tester.tap(find.byKey(const Key('add-block-button')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _createHierarchy(WidgetTester tester) async {
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
