import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';

import 'database_path.dart';

part 'app_database.g.dart';

@DataClassName('WorkspaceRow')
class Workspaces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProjectRow')
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId =>
      text().references(Workspaces, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AppRow')
class Apps extends Table {
  TextColumn get id => text()();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IdeaGroupRow')
class IdeaGroups extends Table {
  TextColumn get id => text()();
  TextColumn get appId =>
      text().references(Apps, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IdeaRow')
class Ideas extends Table {
  TextColumn get id => text()();
  TextColumn get appId =>
      text().references(Apps, #id, onDelete: KeyAction.restrict)();
  TextColumn get groupId => text().nullable().references(
    IdeaGroups,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get lifecycle => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ContentBlockRow')
class ContentBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get ideaId =>
      text().references(Ideas, #id, onDelete: KeyAction.restrict)();
  TextColumn get type => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get textContent => text()();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();
  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Workspaces, Projects, Apps, IdeaGroups, Ideas, ContentBlocks],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.openDefault({DatabasePathProvider? paths}) {
    final pathProvider = paths ?? const WindowsDatabasePathProvider();
    return AppDatabase(
      LazyDatabase(() async {
        final file = await pathProvider.databaseFile();
        return NativeDatabase.createInBackground(file);
      }),
    );
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(ideaGroups);
        await migrator.addColumn(ideas, ideas.groupId);
      }
      if (from < 3) {
        await migrator.createTable(contentBlocks);
        final legacyIdeas = await customSelect(
          'SELECT id, body, created_at, updated_at FROM ideas '
          "WHERE body <> ''",
        ).get();
        await batch((batch) {
          for (final row in legacyIdeas) {
            batch.insert(
              contentBlocks,
              ContentBlocksCompanion.insert(
                id: const Uuid().v7(),
                ideaId: row.read<String>('id'),
                type: 'paragraph',
                sortOrder: 0,
                textContent: row.read<String>('body'),
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                  row.read<int>('created_at') * 1000,
                  isUtc: true,
                ),
                updatedAt: DateTime.fromMillisecondsSinceEpoch(
                  row.read<int>('updated_at') * 1000,
                  isUtc: true,
                ),
              ),
            );
          }
        });
      }
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}
