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
    await tester.tap(find.byTooltip('Open Untitled Idea in focused editor'));
    await tester.pumpAndSettle();
    var blockState = container.read(contentBlockControllerProvider(ideaId));
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
    blockState = container.read(contentBlockControllerProvider(ideaId));
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
        .read(contentBlockControllerProvider(ideaId))
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
        .read(contentBlockControllerProvider(ideaId))
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
    await tester.tap(find.text('Move block up').last);
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
    await tester.drag(
      find.byKey(const Key('idea-workspace-list')),
      const Offset(0, 400),
    );
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
    expect(find.byKey(ValueKey('idea-${ideaId.value}')), findsOneWidget);
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

  testWidgets('editor keyboard, slash menu, undo, and focus stay predictable', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await _pumpProduct(tester, database);
    await _createHierarchy(tester);
    await tester.tap(find.byKey(const Key('new-idea-button')));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(DesktopShell)),
    );
    final ideaId = container.read(ideaControllerProvider).current!.id;
    final controller = container.read(
      contentBlockControllerProvider(ideaId).notifier,
    );
    var state = container.read(contentBlockControllerProvider(ideaId));
    final firstId = state.blocks.single.id;
    final firstField = find.byKey(ValueKey('block-text-${firstId.value}'));

    await tester.enterText(firstField, 'inline');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    state = container.read(contentBlockControllerProvider(ideaId));
    expect(state.blocks, hasLength(1));
    expect(state.blocks.single.text, 'inline\n');
    await controller.undo();
    expect(controller.state.blocks.single.text, isEmpty);
    await controller.redo();
    expect(controller.state.blocks.single.text, 'inline\n');

    await tester.enterText(firstField, '/');
    await tester.pump();
    expect(find.byKey(const Key('slash-command-menu')), findsOneWidget);
    expect(find.bySemanticsLabel('Add block'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(
      container.read(contentBlockControllerProvider(ideaId)).slashSelection,
      1,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.byKey(const Key('slash-command-menu')), findsNothing);
    await tester.enterText(firstField, '/py');
    await tester.pump();
    expect(find.text('Code â€” Python'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    state = container.read(contentBlockControllerProvider(ideaId));
    expect(state.blocks.single.type, ContentBlockType.code);
    expect(state.blocks.single.codeLanguage, 'python');
    final codeField = find.byKey(ValueKey('block-text-${firstId.value}'));
    await tester.enterText(codeField, 'print("grow")\n');
    await tester.pump();
    expect(
      tester.widget<TextField>(codeField).controller?.text,
      'print("grow")\n',
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    state = container.read(contentBlockControllerProvider(ideaId));
    expect(state.blocks, hasLength(2));
    final paragraphId = state.blocks.last.id;
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

    await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
    await tester.pumpAndSettle();
    expect(
      container.read(contentBlockControllerProvider(ideaId)).blocks.first.id,
      paragraphId,
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

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyZ);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(
      container.read(contentBlockControllerProvider(ideaId)).blocks.last.id,
      paragraphId,
    );
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyY);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(
      container.read(contentBlockControllerProvider(ideaId)).blocks.first.id,
      paragraphId,
    );

    await controller.changeType(paragraphId, ContentBlockType.heading);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Heading level'), findsOneWidget);
    expect(find.bySemanticsLabel('Block type and actions menu'), findsWidgets);
    await tester.enterText(paragraphField, 'Heading');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(controller.state.blocks, hasLength(2));
    expect(
      controller.state.blocks
          .firstWhere((block) => block.id == paragraphId)
          .text,
      'Heading\n',
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Select code language'), findsOneWidget);
    state = container.read(contentBlockControllerProvider(ideaId));
    expect(
      state.blocks.firstWhere((block) => block.id == state.activeBlockId).type,
      ContentBlockType.paragraph,
    );
    final checklistId = state.activeBlockId!;
    await controller.changeType(checklistId, ContentBlockType.checklist);
    await tester.pumpAndSettle();
    final checklistField = find.byKey(
      ValueKey('block-text-${checklistId.value}'),
    );
    await tester.enterText(checklistField, 'First line');
    final countBeforeChecklistBreak = controller.state.blocks.length;
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(controller.state.blocks, hasLength(countBeforeChecklistBreak));
    expect(
      controller.state.blocks
          .firstWhere((block) => block.id == checklistId)
          .text,
      'First line\n',
    );

    final language = find.byKey(ValueKey('code-language-${firstId.value}'));
    await tester.ensureVisible(language);
    await tester.tap(language);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dart').last);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<EditableText>(
            find.descendant(of: codeField, matching: find.byType(EditableText)),
          )
          .focusNode
          .hasFocus,
      isTrue,
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
