import 'package:dev_garden/app/app.dart';
import 'package:dev_garden/app/providers.dart';
import 'package:dev_garden/core/preferences/shell_preferences.dart';
import 'package:dev_garden/domain/models/entities.dart';
import 'package:dev_garden/infrastructure/database/app_database.dart';
import 'package:dev_garden/presentation/garden/content_block_controller.dart';
import 'package:dev_garden/presentation/garden/idea_controller.dart';
import 'package:dev_garden/presentation/garden/idea_group_controller.dart';
import 'package:dev_garden/presentation/garden/idea_workspace_controller.dart';
import 'package:dev_garden/presentation/shell/desktop_shell.dart';
import 'package:dev_garden/presentation/shell/shell_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Explorer reflects persisted groups, Ideas, moves, and archives',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await _pumpProduct(tester, database);
      await _createHierarchy(tester);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(DesktopShell)),
      );
      final ideas = container.read(ideaControllerProvider.notifier);
      final groups = container.read(ideaGroupControllerProvider.notifier);

      await groups.create('Research');
      final groupId = container
          .read(ideaGroupControllerProvider)
          .groups
          .single
          .id;
      final grouped = await ideas.capture();
      await _rename(ideas, grouped.id, 'Grouped Idea');
      await ideas.moveToGroup(grouped.id, groupId);
      final ungrouped = await ideas.capture();
      await _rename(ideas, ungrouped.id, 'Ungrouped Idea');
      await tester.pumpAndSettle();

      final groupNode = find.byKey(ValueKey('group-${groupId.value}'));
      final groupedNode = find.byKey(
        ValueKey('explorer-idea-${grouped.id.value}'),
      );
      final ungroupedNode = find.byKey(
        ValueKey('explorer-idea-${ungrouped.id.value}'),
      );
      expect(groupNode, findsOneWidget);
      expect(groupedNode, findsOneWidget);
      expect(find.text('Ungrouped'), findsWidgets);
      expect(ungroupedNode, findsOneWidget);
      expect(find.byKey(const Key('explorer-tree')), findsOneWidget);

      await tester.tap(find.byTooltip('Collapse Idea Group Research'));
      await tester.pump();
      expect(groupedNode, findsNothing);
      expect(ungroupedNode, findsOneWidget);
      await tester.tap(find.byTooltip('Expand Idea Group Research'));
      await tester.pump();

      await ideas.moveToGroup(grouped.id, null);
      await tester.pump();
      await tester.tap(find.byTooltip('Collapse Idea Group Research'));
      await tester.pump();
      expect(groupedNode, findsOneWidget);

      await _rename(ideas, grouped.id, 'Renamed Idea');
      await tester.pump();
      expect(
        find.descendant(of: groupedNode, matching: find.text('Renamed Idea')),
        findsOneWidget,
      );

      await ideas.moveToGroup(grouped.id, groupId);
      await groups.archive(groupId);
      await ideas.refresh();
      await tester.pumpAndSettle();
      expect(groupNode, findsNothing);
      expect(groupedNode, findsOneWidget);
      expect(find.text('Ungrouped'), findsWidgets);

      await ideas.softDelete(grouped.id);
      await tester.pump();
      expect(groupedNode, findsNothing);

      await container
          .read(shellControllerProvider.notifier)
          .setExplorerSide(ExplorerSide.right);
      await tester.pump();
      expect(find.byKey(const Key('project-explorer-region')), findsOneWidget);
    },
  );

  testWidgets('multi-Idea workspace isolates collapse, autosave, and undo', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await _pumpProduct(tester, database);
    await _createHierarchy(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(DesktopShell)),
    );
    final ideas = container.read(ideaControllerProvider.notifier);
    final workspace = container.read(ideaWorkspaceControllerProvider.notifier);

    final first = await ideas.capture();
    await _rename(ideas, first.id, 'First Idea');
    final second = await ideas.capture();
    await _rename(ideas, second.id, 'Second Idea');
    workspace.expand(first.id);
    workspace.reveal(second.id);
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey('idea-${first.id.value}')), findsOneWidget);
    expect(find.byKey(ValueKey('idea-${second.id.value}')), findsOneWidget);
    expect(
      find.byKey(ValueKey('block-list-${first.id.value}')),
      findsOneWidget,
    );
    expect(
      find.byKey(ValueKey('block-list-${second.id.value}')),
      findsOneWidget,
    );

    final firstState = container.read(contentBlockControllerProvider(first.id));
    final secondState = container.read(
      contentBlockControllerProvider(second.id),
    );
    final firstBlock = firstState.blocks.single;
    final secondBlock = secondState.blocks.single;
    final firstField = find.byKey(
      ValueKey('block-text-${firstBlock.id.value}'),
    );
    final secondField = find.byKey(
      ValueKey('block-text-${secondBlock.id.value}'),
    );
    await tester.scrollUntilVisible(
      firstField,
      240,
      scrollable: _workspaceScrollable(),
    );
    await tester.enterText(firstField, 'alpha only');
    await tester.scrollUntilVisible(
      secondField,
      -240,
      scrollable: _workspaceScrollable(),
    );
    await tester.enterText(secondField, 'beta only');
    await container
        .read(contentBlockSessionCoordinatorProvider.notifier)
        .flushAll();

    final repository = container.read(contentBlockRepositoryProvider);
    expect(
      (await repository.listActiveByIdea(first.id)).single.text,
      'alpha only',
    );
    expect(
      (await repository.listActiveByIdea(second.id)).single.text,
      'beta only',
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyZ);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    expect(
      container
          .read(contentBlockControllerProvider(first.id))
          .blocks
          .single
          .text,
      'alpha only',
    );
    expect(
      container
          .read(contentBlockControllerProvider(second.id))
          .blocks
          .single
          .text,
      isEmpty,
    );

    await tester.scrollUntilVisible(
      find.byTooltip('Collapse Idea First Idea'),
      240,
      scrollable: _workspaceScrollable(),
    );
    await tester.tap(find.byTooltip('Collapse Idea First Idea'));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('block-list-${first.id.value}')), findsNothing);
    expect(
      find.byKey(ValueKey('block-list-${second.id.value}')),
      findsOneWidget,
    );
    expect(
      (await repository.listActiveByIdea(first.id)).single.text,
      'alpha only',
    );

    final explorerFirst = find.byKey(
      ValueKey('explorer-idea-${first.id.value}'),
    );
    await tester.ensureVisible(explorerFirst);
    await tester.tap(explorerFirst);
    await tester.pumpAndSettle();
    expect(
      find.byKey(ValueKey('block-list-${first.id.value}')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('idea-search-field')),
      'alpha only',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('idea-${first.id.value}')), findsOneWidget);
    expect(find.byKey(ValueKey('idea-${second.id.value}')), findsNothing);
  });

  testWidgets('new Idea expands and focuses its initial Paragraph', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await _pumpProduct(tester, database);
    await _createHierarchy(tester);
    final initialContainer = ProviderScope.containerOf(
      tester.element(find.byType(DesktopShell)),
    );
    final existing = await initialContainer
        .read(ideaControllerProvider.notifier)
        .capture();
    await _rename(
      initialContainer.read(ideaControllerProvider.notifier),
      existing.id,
      'Existing Idea',
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('idea-search-field')),
      'no matches',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('new-idea-button')));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(DesktopShell)),
    );
    final idea = container.read(ideaControllerProvider).current!;
    final block = container
        .read(contentBlockControllerProvider(idea.id))
        .blocks
        .single;
    final field = find.byKey(ValueKey('block-text-${block.id.value}'));
    expect(field, findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('idea-search-field')))
          .controller
          ?.text,
      isEmpty,
    );
    expect(
      tester
          .widget<EditableText>(
            find.descendant(of: field, matching: find.byType(EditableText)),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
  });
}

Future<void> _rename(
  IdeaController controller,
  EntityId id,
  String title,
) async {
  await controller.open(id);
  controller.updateDraftTitle(title);
  await controller.flush();
}

Future<void> _createHierarchy(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('empty-create-workspace-button')));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const Key('workspace-name-field')),
    'Workspace',
  );
  await tester.tap(find.byKey(const Key('confirm-name-button')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Create Project'));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const Key('project-name-field')),
    'Project',
  );
  await tester.tap(find.byKey(const Key('confirm-name-button')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Create App'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('app-name-field')), 'App');
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

Finder _workspaceScrollable() => find
    .descendant(
      of: find.byKey(const Key('idea-workspace-list')),
      matching: find.byType(Scrollable),
    )
    .first;
