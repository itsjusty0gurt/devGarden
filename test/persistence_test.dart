import 'dart:io';

import 'package:dev_garden/application/services/hierarchy_service.dart';
import 'package:dev_garden/application/services/id_generator.dart';
import 'package:dev_garden/application/services/idea_service.dart';
import 'package:dev_garden/domain/models/entities.dart';
import 'package:dev_garden/infrastructure/database/app_database.dart';
import 'package:dev_garden/infrastructure/repositories/drift_repositories.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Drift persistence slice', () {
    late AppDatabase database;
    late _Fixture fixture;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      fixture = _Fixture(database);
    });

    tearDown(() => database.close());

    test(
      'UUID v7 identity is assigned before persistence and preserved',
      () async {
        final hierarchy = await fixture.createHierarchy();
        final idea = await fixture.ideaService.capture(hierarchy.app.id);

        for (final id in [
          hierarchy.workspace.id,
          hierarchy.project.id,
          hierarchy.app.id,
          idea.id,
        ]) {
          expect(id.value, matches(_uuidV7Pattern));
        }
        expect((await fixture.ideas.getById(idea.id))?.id, idea.id);
      },
    );

    test('Workspace creation persists and lists active records', () async {
      final workspace = await fixture.hierarchyService.createWorkspace(
        'Garden',
      );

      final restored = await fixture.workspaces.listActive();

      expect(restored.single.id, workspace.id);
      expect(restored.single.name, 'Garden');
    });

    test('Project and App preserve their hierarchy relationships', () async {
      final hierarchy = await fixture.createHierarchy();

      final projects = await fixture.projects.listActiveByWorkspace(
        hierarchy.workspace.id,
      );
      final apps = await fixture.apps.listActiveByProject(hierarchy.project.id);

      expect(projects.single.workspaceId, hierarchy.workspace.id);
      expect(apps.single.projectId, hierarchy.project.id);
    });

    test('Idea belongs to App and title/body updates persist', () async {
      final hierarchy = await fixture.createHierarchy();
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      final originalUpdatedAt = idea.updatedAt;
      fixture.advanceClock();

      final updated = await fixture.ideaService.update(
        idea.id,
        'Renamed Idea',
        'Recognizable body text',
      );
      final restored = await fixture.ideas.getById(idea.id);

      expect(updated.appId, hierarchy.app.id);
      expect(restored?.title, 'Renamed Idea');
      expect(restored?.body, 'Recognizable body text');
      expect(restored?.updatedAt.isAfter(originalUpdatedAt), isTrue);
    });

    test('search finds title and body matches', () async {
      final hierarchy = await fixture.createHierarchy();
      final first = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.ideaService.update(
        first.id,
        'Compiler garden',
        'plain body',
      );
      final second = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.ideaService.update(
        second.id,
        'Other title',
        'riverpod notes',
      );

      final titleMatches = await fixture.ideaService.search(
        hierarchy.app.id,
        'compiler',
      );
      final bodyMatches = await fixture.ideaService.search(
        hierarchy.app.id,
        'riverpod',
      );

      expect(titleMatches.map((idea) => idea.id), contains(first.id));
      expect(bodyMatches.map((idea) => idea.id), contains(second.id));
    });

    test('soft deletion excludes Ideas from active lists and search', () async {
      final hierarchy = await fixture.createHierarchy();
      final idea = await fixture.ideaService.capture(hierarchy.app.id);
      await fixture.ideaService.update(idea.id, 'Archive target', 'searchable');

      await fixture.ideaService.softDelete(idea.id);

      expect(await fixture.ideas.listActiveByApp(hierarchy.app.id), isEmpty);
      expect(
        await fixture.ideaService.search(hierarchy.app.id, 'searchable'),
        isEmpty,
      );
      final retained = await fixture.ideas.getById(idea.id);
      expect(retained, isNotNull);
      expect(retained!.isDeleted, isTrue);
    });
  });

  test('database survives close and reopen from a temporary file', () async {
    final directory = await Directory.systemTemp.createTemp(
      'dev_garden_database_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}${Platform.pathSeparator}slice.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final firstFixture = _Fixture(firstDatabase);
    final hierarchy = await firstFixture.createHierarchy();
    final idea = await firstFixture.ideaService.capture(hierarchy.app.id);
    await firstFixture.ideaService.update(
      idea.id,
      'Persistent title',
      'Persistent body',
    );
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final reopenedIdeas = DriftIdeaRepository(reopenedDatabase);
    final restored = await reopenedIdeas.getById(idea.id);

    expect(restored?.title, 'Persistent title');
    expect(restored?.body, 'Persistent body');
    expect(restored?.id, idea.id);
  });
}

final _uuidV7Pattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

class _Fixture {
  _Fixture(AppDatabase database)
    : workspaces = DriftWorkspaceRepository(database),
      projects = DriftProjectRepository(database),
      apps = DriftAppRepository(database),
      ideas = DriftIdeaRepository(database) {
    hierarchyService = HierarchyService(
      workspaces,
      projects,
      apps,
      const UuidV7IdGenerator(),
      () => now,
    );
    ideaService = IdeaService(ideas, const UuidV7IdGenerator(), () => now);
  }

  DateTime now = DateTime.utc(2026, 8, 7, 12);
  final DriftWorkspaceRepository workspaces;
  final DriftProjectRepository projects;
  final DriftAppRepository apps;
  final DriftIdeaRepository ideas;
  late final HierarchyService hierarchyService;
  late final IdeaService ideaService;

  void advanceClock() {
    now = now.add(const Duration(minutes: 1));
  }

  Future<_Hierarchy> createHierarchy() async {
    final workspace = await hierarchyService.createWorkspace('Workspace');
    final project = await hierarchyService.createProject(
      workspace.id,
      'Project',
    );
    final app = await hierarchyService.createApp(project.id, 'App');
    return _Hierarchy(workspace, project, app);
  }
}

class _Hierarchy {
  const _Hierarchy(this.workspace, this.project, this.app);

  final Workspace workspace;
  final Project project;
  final GardenApp app;
}
