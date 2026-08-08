// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkspacesTable extends Workspaces
    with TableInfo<$WorkspacesTable, WorkspaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkspacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    updatedAt,
    sortOrder,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workspaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkspaceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkspaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkspaceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $WorkspacesTable createAlias(String alias) {
    return $WorkspacesTable(attachedDatabase, alias);
  }
}

class WorkspaceRow extends DataClass implements Insertable<WorkspaceRow> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isDeleted;
  const WorkspaceRow({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  WorkspacesCompanion toCompanion(bool nullToAbsent) {
    return WorkspacesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
    );
  }

  factory WorkspaceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkspaceRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  WorkspaceRow copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
    bool? isDeleted,
  }) => WorkspaceRow(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  WorkspaceRow copyWithCompanion(WorkspacesCompanion data) {
    return WorkspaceRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkspaceRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, createdAt, updatedAt, sortOrder, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkspaceRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted);
}

class WorkspacesCompanion extends UpdateCompanion<WorkspaceRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> sortOrder;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const WorkspacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkspacesCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int sortOrder,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sortOrder = Value(sortOrder);
  static Insertable<WorkspaceRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? sortOrder,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkspacesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? sortOrder,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return WorkspacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkspacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workspaces (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    name,
    createdAt,
    updatedAt,
    sortOrder,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final String id;
  final String workspaceId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isDeleted;
  const ProjectRow({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
    );
  }

  factory ProjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ProjectRow copyWith({
    String? id,
    String? workspaceId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
    bool? isDeleted,
  }) => ProjectRow(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    name,
    createdAt,
    updatedAt,
    sortOrder,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> sortOrder;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String workspaceId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int sortOrder,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sortOrder = Value(sortOrder);
  static Insertable<ProjectRow> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? sortOrder,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? sortOrder,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppsTable extends Apps with TableInfo<$AppsTable, AppRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    createdAt,
    updatedAt,
    sortOrder,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apps';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $AppsTable createAlias(String alias) {
    return $AppsTable(attachedDatabase, alias);
  }
}

class AppRow extends DataClass implements Insertable<AppRow> {
  final String id;
  final String projectId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isDeleted;
  const AppRow({
    required this.id,
    required this.projectId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  AppsCompanion toCompanion(bool nullToAbsent) {
    return AppsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
    );
  }

  factory AppRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  AppRow copyWith({
    String? id,
    String? projectId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
    bool? isDeleted,
  }) => AppRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  AppRow copyWithCompanion(AppsCompanion data) {
    return AppRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    createdAt,
    updatedAt,
    sortOrder,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted);
}

class AppsCompanion extends UpdateCompanion<AppRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> sortOrder;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const AppsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppsCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int sortOrder,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sortOrder = Value(sortOrder);
  static Insertable<AppRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? sortOrder,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? sortOrder,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return AppsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdeaGroupsTable extends IdeaGroups
    with TableInfo<$IdeaGroupsTable, IdeaGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdeaGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
    'app_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apps (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appId,
    name,
    createdAt,
    updatedAt,
    sortOrder,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'idea_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdeaGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
        _appIdMeta,
        appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta),
      );
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IdeaGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdeaGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      appId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $IdeaGroupsTable createAlias(String alias) {
    return $IdeaGroupsTable(attachedDatabase, alias);
  }
}

class IdeaGroupRow extends DataClass implements Insertable<IdeaGroupRow> {
  final String id;
  final String appId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isDeleted;
  const IdeaGroupRow({
    required this.id,
    required this.appId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_id'] = Variable<String>(appId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  IdeaGroupsCompanion toCompanion(bool nullToAbsent) {
    return IdeaGroupsCompanion(
      id: Value(id),
      appId: Value(appId),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
    );
  }

  factory IdeaGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdeaGroupRow(
      id: serializer.fromJson<String>(json['id']),
      appId: serializer.fromJson<String>(json['appId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appId': serializer.toJson<String>(appId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  IdeaGroupRow copyWith({
    String? id,
    String? appId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
    bool? isDeleted,
  }) => IdeaGroupRow(
    id: id ?? this.id,
    appId: appId ?? this.appId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  IdeaGroupRow copyWithCompanion(IdeaGroupsCompanion data) {
    return IdeaGroupRow(
      id: data.id.present ? data.id.value : this.id,
      appId: data.appId.present ? data.appId.value : this.appId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdeaGroupRow(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, appId, name, createdAt, updatedAt, sortOrder, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdeaGroupRow &&
          other.id == this.id &&
          other.appId == this.appId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted);
}

class IdeaGroupsCompanion extends UpdateCompanion<IdeaGroupRow> {
  final Value<String> id;
  final Value<String> appId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> sortOrder;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const IdeaGroupsCompanion({
    this.id = const Value.absent(),
    this.appId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdeaGroupsCompanion.insert({
    required String id,
    required String appId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int sortOrder,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       appId = Value(appId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sortOrder = Value(sortOrder);
  static Insertable<IdeaGroupRow> custom({
    Expression<String>? id,
    Expression<String>? appId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? sortOrder,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appId != null) 'app_id': appId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdeaGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? appId,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? sortOrder,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return IdeaGroupsCompanion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdeaGroupsCompanion(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdeasTable extends Ideas with TableInfo<$IdeasTable, IdeaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdeasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
    'app_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES apps (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES idea_groups (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifecycleMeta = const VerificationMeta(
    'lifecycle',
  );
  @override
  late final GeneratedColumn<String> lifecycle = GeneratedColumn<String>(
    'lifecycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appId,
    groupId,
    title,
    body,
    lifecycle,
    createdAt,
    updatedAt,
    sortOrder,
    isPinned,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ideas';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdeaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
        _appIdMeta,
        appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta),
      );
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('lifecycle')) {
      context.handle(
        _lifecycleMeta,
        lifecycle.isAcceptableOrUnknown(data['lifecycle']!, _lifecycleMeta),
      );
    } else if (isInserting) {
      context.missing(_lifecycleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IdeaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdeaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      appId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      lifecycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lifecycle'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $IdeasTable createAlias(String alias) {
    return $IdeasTable(attachedDatabase, alias);
  }
}

class IdeaRow extends DataClass implements Insertable<IdeaRow> {
  final String id;
  final String appId;
  final String? groupId;
  final String title;
  final String body;
  final String lifecycle;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isPinned;
  final bool isDeleted;
  const IdeaRow({
    required this.id,
    required this.appId,
    this.groupId,
    required this.title,
    required this.body,
    required this.lifecycle,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isPinned,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_id'] = Variable<String>(appId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['lifecycle'] = Variable<String>(lifecycle);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  IdeasCompanion toCompanion(bool nullToAbsent) {
    return IdeasCompanion(
      id: Value(id),
      appId: Value(appId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      title: Value(title),
      body: Value(body),
      lifecycle: Value(lifecycle),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sortOrder: Value(sortOrder),
      isPinned: Value(isPinned),
      isDeleted: Value(isDeleted),
    );
  }

  factory IdeaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdeaRow(
      id: serializer.fromJson<String>(json['id']),
      appId: serializer.fromJson<String>(json['appId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      lifecycle: serializer.fromJson<String>(json['lifecycle']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appId': serializer.toJson<String>(appId),
      'groupId': serializer.toJson<String?>(groupId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'lifecycle': serializer.toJson<String>(lifecycle),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  IdeaRow copyWith({
    String? id,
    String? appId,
    Value<String?> groupId = const Value.absent(),
    String? title,
    String? body,
    String? lifecycle,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
    bool? isPinned,
    bool? isDeleted,
  }) => IdeaRow(
    id: id ?? this.id,
    appId: appId ?? this.appId,
    groupId: groupId.present ? groupId.value : this.groupId,
    title: title ?? this.title,
    body: body ?? this.body,
    lifecycle: lifecycle ?? this.lifecycle,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    isPinned: isPinned ?? this.isPinned,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  IdeaRow copyWithCompanion(IdeasCompanion data) {
    return IdeaRow(
      id: data.id.present ? data.id.value : this.id,
      appId: data.appId.present ? data.appId.value : this.appId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      lifecycle: data.lifecycle.present ? data.lifecycle.value : this.lifecycle,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdeaRow(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isPinned: $isPinned, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    appId,
    groupId,
    title,
    body,
    lifecycle,
    createdAt,
    updatedAt,
    sortOrder,
    isPinned,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdeaRow &&
          other.id == this.id &&
          other.appId == this.appId &&
          other.groupId == this.groupId &&
          other.title == this.title &&
          other.body == this.body &&
          other.lifecycle == this.lifecycle &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder &&
          other.isPinned == this.isPinned &&
          other.isDeleted == this.isDeleted);
}

class IdeasCompanion extends UpdateCompanion<IdeaRow> {
  final Value<String> id;
  final Value<String> appId;
  final Value<String?> groupId;
  final Value<String> title;
  final Value<String> body;
  final Value<String> lifecycle;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> sortOrder;
  final Value<bool> isPinned;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const IdeasCompanion({
    this.id = const Value.absent(),
    this.appId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.lifecycle = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdeasCompanion.insert({
    required String id,
    required String appId,
    this.groupId = const Value.absent(),
    required String title,
    required String body,
    required String lifecycle,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int sortOrder,
    this.isPinned = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       appId = Value(appId),
       title = Value(title),
       body = Value(body),
       lifecycle = Value(lifecycle),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sortOrder = Value(sortOrder);
  static Insertable<IdeaRow> custom({
    Expression<String>? id,
    Expression<String>? appId,
    Expression<String>? groupId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? lifecycle,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? sortOrder,
    Expression<bool>? isPinned,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appId != null) 'app_id': appId,
      if (groupId != null) 'group_id': groupId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (lifecycle != null) 'lifecycle': lifecycle,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdeasCompanion copyWith({
    Value<String>? id,
    Value<String>? appId,
    Value<String?>? groupId,
    Value<String>? title,
    Value<String>? body,
    Value<String>? lifecycle,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? sortOrder,
    Value<bool>? isPinned,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return IdeasCompanion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      body: body ?? this.body,
      lifecycle: lifecycle ?? this.lifecycle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isPinned: isPinned ?? this.isPinned,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (lifecycle.present) {
      map['lifecycle'] = Variable<String>(lifecycle.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdeasCompanion(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isPinned: $isPinned, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentBlocksTable extends ContentBlocks
    with TableInfo<$ContentBlocksTable, ContentBlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ideaIdMeta = const VerificationMeta('ideaId');
  @override
  late final GeneratedColumn<String> ideaId = GeneratedColumn<String>(
    'idea_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ideas (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ideaId,
    type,
    sortOrder,
    textContent,
    metadataJson,
    payloadVersion,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentBlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('idea_id')) {
      context.handle(
        _ideaIdMeta,
        ideaId.isAcceptableOrUnknown(data['idea_id']!, _ideaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ideaIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(
          data['text_content']!,
          _textContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentBlockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentBlockRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ideaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idea_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_content'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ContentBlocksTable createAlias(String alias) {
    return $ContentBlocksTable(attachedDatabase, alias);
  }
}

class ContentBlockRow extends DataClass implements Insertable<ContentBlockRow> {
  final String id;
  final String ideaId;
  final String type;
  final int sortOrder;
  final String textContent;
  final String metadataJson;
  final int payloadVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const ContentBlockRow({
    required this.id,
    required this.ideaId,
    required this.type,
    required this.sortOrder,
    required this.textContent,
    required this.metadataJson,
    required this.payloadVersion,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['idea_id'] = Variable<String>(ideaId);
    map['type'] = Variable<String>(type);
    map['sort_order'] = Variable<int>(sortOrder);
    map['text_content'] = Variable<String>(textContent);
    map['metadata_json'] = Variable<String>(metadataJson);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ContentBlocksCompanion toCompanion(bool nullToAbsent) {
    return ContentBlocksCompanion(
      id: Value(id),
      ideaId: Value(ideaId),
      type: Value(type),
      sortOrder: Value(sortOrder),
      textContent: Value(textContent),
      metadataJson: Value(metadataJson),
      payloadVersion: Value(payloadVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory ContentBlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentBlockRow(
      id: serializer.fromJson<String>(json['id']),
      ideaId: serializer.fromJson<String>(json['ideaId']),
      type: serializer.fromJson<String>(json['type']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      textContent: serializer.fromJson<String>(json['textContent']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ideaId': serializer.toJson<String>(ideaId),
      'type': serializer.toJson<String>(type),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'textContent': serializer.toJson<String>(textContent),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ContentBlockRow copyWith({
    String? id,
    String? ideaId,
    String? type,
    int? sortOrder,
    String? textContent,
    String? metadataJson,
    int? payloadVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => ContentBlockRow(
    id: id ?? this.id,
    ideaId: ideaId ?? this.ideaId,
    type: type ?? this.type,
    sortOrder: sortOrder ?? this.sortOrder,
    textContent: textContent ?? this.textContent,
    metadataJson: metadataJson ?? this.metadataJson,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ContentBlockRow copyWithCompanion(ContentBlocksCompanion data) {
    return ContentBlockRow(
      id: data.id.present ? data.id.value : this.id,
      ideaId: data.ideaId.present ? data.ideaId.value : this.ideaId,
      type: data.type.present ? data.type.value : this.type,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentBlockRow(')
          ..write('id: $id, ')
          ..write('ideaId: $ideaId, ')
          ..write('type: $type, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('textContent: $textContent, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ideaId,
    type,
    sortOrder,
    textContent,
    metadataJson,
    payloadVersion,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentBlockRow &&
          other.id == this.id &&
          other.ideaId == this.ideaId &&
          other.type == this.type &&
          other.sortOrder == this.sortOrder &&
          other.textContent == this.textContent &&
          other.metadataJson == this.metadataJson &&
          other.payloadVersion == this.payloadVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class ContentBlocksCompanion extends UpdateCompanion<ContentBlockRow> {
  final Value<String> id;
  final Value<String> ideaId;
  final Value<String> type;
  final Value<int> sortOrder;
  final Value<String> textContent;
  final Value<String> metadataJson;
  final Value<int> payloadVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ContentBlocksCompanion({
    this.id = const Value.absent(),
    this.ideaId = const Value.absent(),
    this.type = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.textContent = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentBlocksCompanion.insert({
    required String id,
    required String ideaId,
    required String type,
    required int sortOrder,
    required String textContent,
    this.metadataJson = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ideaId = Value(ideaId),
       type = Value(type),
       sortOrder = Value(sortOrder),
       textContent = Value(textContent),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ContentBlockRow> custom({
    Expression<String>? id,
    Expression<String>? ideaId,
    Expression<String>? type,
    Expression<int>? sortOrder,
    Expression<String>? textContent,
    Expression<String>? metadataJson,
    Expression<int>? payloadVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ideaId != null) 'idea_id': ideaId,
      if (type != null) 'type': type,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (textContent != null) 'text_content': textContent,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentBlocksCompanion copyWith({
    Value<String>? id,
    Value<String>? ideaId,
    Value<String>? type,
    Value<int>? sortOrder,
    Value<String>? textContent,
    Value<String>? metadataJson,
    Value<int>? payloadVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ContentBlocksCompanion(
      id: id ?? this.id,
      ideaId: ideaId ?? this.ideaId,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
      textContent: textContent ?? this.textContent,
      metadataJson: metadataJson ?? this.metadataJson,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ideaId.present) {
      map['idea_id'] = Variable<String>(ideaId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentBlocksCompanion(')
          ..write('id: $id, ')
          ..write('ideaId: $ideaId, ')
          ..write('type: $type, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('textContent: $textContent, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkspacesTable workspaces = $WorkspacesTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $AppsTable apps = $AppsTable(this);
  late final $IdeaGroupsTable ideaGroups = $IdeaGroupsTable(this);
  late final $IdeasTable ideas = $IdeasTable(this);
  late final $ContentBlocksTable contentBlocks = $ContentBlocksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workspaces,
    projects,
    apps,
    ideaGroups,
    ideas,
    contentBlocks,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idea_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ideas', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$WorkspacesTableCreateCompanionBuilder =
    WorkspacesCompanion Function({
      required String id,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      required int sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$WorkspacesTableUpdateCompanionBuilder =
    WorkspacesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

final class $$WorkspacesTableReferences
    extends BaseReferences<_$AppDatabase, $WorkspacesTable, WorkspaceRow> {
  $$WorkspacesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProjectsTable, List<ProjectRow>>
  _projectsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'workspaces__id__projects__workspace_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.workspaceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkspacesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.workspaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkspacesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkspacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.workspaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkspacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkspacesTable,
          WorkspaceRow,
          $$WorkspacesTableFilterComposer,
          $$WorkspacesTableOrderingComposer,
          $$WorkspacesTableAnnotationComposer,
          $$WorkspacesTableCreateCompanionBuilder,
          $$WorkspacesTableUpdateCompanionBuilder,
          (WorkspaceRow, $$WorkspacesTableReferences),
          WorkspaceRow,
          PrefetchHooks Function({bool projectsRefs})
        > {
  $$WorkspacesTableTableManager(_$AppDatabase db, $WorkspacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkspacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkspacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkspacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                required int sortOrder,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkspacesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (projectsRefs) db.projects],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (projectsRefs)
                    await $_getPrefetchedData<
                      WorkspaceRow,
                      $WorkspacesTable,
                      ProjectRow
                    >(
                      currentTable: table,
                      referencedTable: $$WorkspacesTableReferences
                          ._projectsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkspacesTableReferences(
                            db,
                            table,
                            p0,
                          ).projectsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.workspaceId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkspacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkspacesTable,
      WorkspaceRow,
      $$WorkspacesTableFilterComposer,
      $$WorkspacesTableOrderingComposer,
      $$WorkspacesTableAnnotationComposer,
      $$WorkspacesTableCreateCompanionBuilder,
      $$WorkspacesTableUpdateCompanionBuilder,
      (WorkspaceRow, $$WorkspacesTableReferences),
      WorkspaceRow,
      PrefetchHooks Function({bool projectsRefs})
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String workspaceId,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      required int sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkspacesTable _workspaceIdTable(_$AppDatabase db) =>
      db.workspaces.createAlias('projects__workspace_id__workspaces__id');

  $$WorkspacesTableProcessedTableManager get workspaceId {
    final $_column = $_itemColumn<String>('workspace_id')!;

    final manager = $$WorkspacesTableTableManager(
      $_db,
      $_db.workspaces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workspaceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AppsTable, List<AppRow>> _appsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.apps,
    aliasName: 'projects__id__apps__project_id',
  );

  $$AppsTableProcessedTableManager get appsRefs {
    final manager = $$AppsTableTableManager(
      $_db,
      $_db.apps,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_appsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkspacesTableFilterComposer get workspaceId {
    final $$WorkspacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workspaceId,
      referencedTable: $db.workspaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkspacesTableFilterComposer(
            $db: $db,
            $table: $db.workspaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> appsRefs(
    Expression<bool> Function($$AppsTableFilterComposer f) f,
  ) {
    final $$AppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableFilterComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkspacesTableOrderingComposer get workspaceId {
    final $$WorkspacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workspaceId,
      referencedTable: $db.workspaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkspacesTableOrderingComposer(
            $db: $db,
            $table: $db.workspaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$WorkspacesTableAnnotationComposer get workspaceId {
    final $$WorkspacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workspaceId,
      referencedTable: $db.workspaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkspacesTableAnnotationComposer(
            $db: $db,
            $table: $db.workspaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> appsRefs<T extends Object>(
    Expression<T> Function($$AppsTableAnnotationComposer a) f,
  ) {
    final $$AppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableAnnotationComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (ProjectRow, $$ProjectsTableReferences),
          ProjectRow,
          PrefetchHooks Function({bool workspaceId, bool appsRefs})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                workspaceId: workspaceId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                required int sortOrder,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workspaceId = false, appsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (appsRefs) db.apps],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workspaceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workspaceId,
                                referencedTable: $$ProjectsTableReferences
                                    ._workspaceIdTable(db),
                                referencedColumn: $$ProjectsTableReferences
                                    ._workspaceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (appsRefs)
                    await $_getPrefetchedData<
                      ProjectRow,
                      $ProjectsTable,
                      AppRow
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences._appsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$ProjectsTableReferences(db, table, p0).appsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectRow, $$ProjectsTableReferences),
      ProjectRow,
      PrefetchHooks Function({bool workspaceId, bool appsRefs})
    >;
typedef $$AppsTableCreateCompanionBuilder =
    AppsCompanion Function({
      required String id,
      required String projectId,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      required int sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$AppsTableUpdateCompanionBuilder =
    AppsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

final class $$AppsTableReferences
    extends BaseReferences<_$AppDatabase, $AppsTable, AppRow> {
  $$AppsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('apps__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IdeaGroupsTable, List<IdeaGroupRow>>
  _ideaGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ideaGroups,
    aliasName: 'apps__id__idea_groups__app_id',
  );

  $$IdeaGroupsTableProcessedTableManager get ideaGroupsRefs {
    final manager = $$IdeaGroupsTableTableManager(
      $_db,
      $_db.ideaGroups,
    ).filter((f) => f.appId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ideaGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IdeasTable, List<IdeaRow>> _ideasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ideas,
    aliasName: 'apps__id__ideas__app_id',
  );

  $$IdeasTableProcessedTableManager get ideasRefs {
    final manager = $$IdeasTableTableManager(
      $_db,
      $_db.ideas,
    ).filter((f) => f.appId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ideasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AppsTableFilterComposer extends Composer<_$AppDatabase, $AppsTable> {
  $$AppsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ideaGroupsRefs(
    Expression<bool> Function($$IdeaGroupsTableFilterComposer f) f,
  ) {
    final $$IdeaGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ideaGroups,
      getReferencedColumn: (t) => t.appId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeaGroupsTableFilterComposer(
            $db: $db,
            $table: $db.ideaGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ideasRefs(
    Expression<bool> Function($$IdeasTableFilterComposer f) f,
  ) {
    final $$IdeasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ideas,
      getReferencedColumn: (t) => t.appId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeasTableFilterComposer(
            $db: $db,
            $table: $db.ideas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AppsTableOrderingComposer extends Composer<_$AppDatabase, $AppsTable> {
  $$AppsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppsTable> {
  $$AppsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ideaGroupsRefs<T extends Object>(
    Expression<T> Function($$IdeaGroupsTableAnnotationComposer a) f,
  ) {
    final $$IdeaGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ideaGroups,
      getReferencedColumn: (t) => t.appId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeaGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.ideaGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ideasRefs<T extends Object>(
    Expression<T> Function($$IdeasTableAnnotationComposer a) f,
  ) {
    final $$IdeasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ideas,
      getReferencedColumn: (t) => t.appId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeasTableAnnotationComposer(
            $db: $db,
            $table: $db.ideas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AppsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppsTable,
          AppRow,
          $$AppsTableFilterComposer,
          $$AppsTableOrderingComposer,
          $$AppsTableAnnotationComposer,
          $$AppsTableCreateCompanionBuilder,
          $$AppsTableUpdateCompanionBuilder,
          (AppRow, $$AppsTableReferences),
          AppRow,
          PrefetchHooks Function({
            bool projectId,
            bool ideaGroupsRefs,
            bool ideasRefs,
          })
        > {
  $$AppsTableTableManager(_$AppDatabase db, $AppsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                required int sortOrder,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AppsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, ideaGroupsRefs = false, ideasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ideaGroupsRefs) db.ideaGroups,
                    if (ideasRefs) db.ideas,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$AppsTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$AppsTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ideaGroupsRefs)
                        await $_getPrefetchedData<
                          AppRow,
                          $AppsTable,
                          IdeaGroupRow
                        >(
                          currentTable: table,
                          referencedTable: $$AppsTableReferences
                              ._ideaGroupsRefsTable(db),
                          managerFromTypedResult: (p0) => $$AppsTableReferences(
                            db,
                            table,
                            p0,
                          ).ideaGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ideasRefs)
                        await $_getPrefetchedData<AppRow, $AppsTable, IdeaRow>(
                          currentTable: table,
                          referencedTable: $$AppsTableReferences
                              ._ideasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppsTableReferences(db, table, p0).ideasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AppsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppsTable,
      AppRow,
      $$AppsTableFilterComposer,
      $$AppsTableOrderingComposer,
      $$AppsTableAnnotationComposer,
      $$AppsTableCreateCompanionBuilder,
      $$AppsTableUpdateCompanionBuilder,
      (AppRow, $$AppsTableReferences),
      AppRow,
      PrefetchHooks Function({
        bool projectId,
        bool ideaGroupsRefs,
        bool ideasRefs,
      })
    >;
typedef $$IdeaGroupsTableCreateCompanionBuilder =
    IdeaGroupsCompanion Function({
      required String id,
      required String appId,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      required int sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$IdeaGroupsTableUpdateCompanionBuilder =
    IdeaGroupsCompanion Function({
      Value<String> id,
      Value<String> appId,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> sortOrder,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

final class $$IdeaGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $IdeaGroupsTable, IdeaGroupRow> {
  $$IdeaGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AppsTable _appIdTable(_$AppDatabase db) =>
      db.apps.createAlias('idea_groups__app_id__apps__id');

  $$AppsTableProcessedTableManager get appId {
    final $_column = $_itemColumn<String>('app_id')!;

    final manager = $$AppsTableTableManager(
      $_db,
      $_db.apps,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IdeasTable, List<IdeaRow>> _ideasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ideas,
    aliasName: 'idea_groups__id__ideas__group_id',
  );

  $$IdeasTableProcessedTableManager get ideasRefs {
    final manager = $$IdeasTableTableManager(
      $_db,
      $_db.ideas,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ideasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IdeaGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $IdeaGroupsTable> {
  $$IdeaGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$AppsTableFilterComposer get appId {
    final $$AppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appId,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableFilterComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ideasRefs(
    Expression<bool> Function($$IdeasTableFilterComposer f) f,
  ) {
    final $$IdeasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ideas,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeasTableFilterComposer(
            $db: $db,
            $table: $db.ideas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IdeaGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdeaGroupsTable> {
  $$IdeaGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppsTableOrderingComposer get appId {
    final $$AppsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appId,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableOrderingComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdeaGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdeaGroupsTable> {
  $$IdeaGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$AppsTableAnnotationComposer get appId {
    final $$AppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appId,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableAnnotationComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ideasRefs<T extends Object>(
    Expression<T> Function($$IdeasTableAnnotationComposer a) f,
  ) {
    final $$IdeasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ideas,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeasTableAnnotationComposer(
            $db: $db,
            $table: $db.ideas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IdeaGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdeaGroupsTable,
          IdeaGroupRow,
          $$IdeaGroupsTableFilterComposer,
          $$IdeaGroupsTableOrderingComposer,
          $$IdeaGroupsTableAnnotationComposer,
          $$IdeaGroupsTableCreateCompanionBuilder,
          $$IdeaGroupsTableUpdateCompanionBuilder,
          (IdeaGroupRow, $$IdeaGroupsTableReferences),
          IdeaGroupRow,
          PrefetchHooks Function({bool appId, bool ideasRefs})
        > {
  $$IdeaGroupsTableTableManager(_$AppDatabase db, $IdeaGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdeaGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdeaGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdeaGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> appId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeaGroupsCompanion(
                id: id,
                appId: appId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String appId,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                required int sortOrder,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeaGroupsCompanion.insert(
                id: id,
                appId: appId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IdeaGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({appId = false, ideasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ideasRefs) db.ideas],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (appId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.appId,
                                referencedTable: $$IdeaGroupsTableReferences
                                    ._appIdTable(db),
                                referencedColumn: $$IdeaGroupsTableReferences
                                    ._appIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ideasRefs)
                    await $_getPrefetchedData<
                      IdeaGroupRow,
                      $IdeaGroupsTable,
                      IdeaRow
                    >(
                      currentTable: table,
                      referencedTable: $$IdeaGroupsTableReferences
                          ._ideasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$IdeaGroupsTableReferences(db, table, p0).ideasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IdeaGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdeaGroupsTable,
      IdeaGroupRow,
      $$IdeaGroupsTableFilterComposer,
      $$IdeaGroupsTableOrderingComposer,
      $$IdeaGroupsTableAnnotationComposer,
      $$IdeaGroupsTableCreateCompanionBuilder,
      $$IdeaGroupsTableUpdateCompanionBuilder,
      (IdeaGroupRow, $$IdeaGroupsTableReferences),
      IdeaGroupRow,
      PrefetchHooks Function({bool appId, bool ideasRefs})
    >;
typedef $$IdeasTableCreateCompanionBuilder =
    IdeasCompanion Function({
      required String id,
      required String appId,
      Value<String?> groupId,
      required String title,
      required String body,
      required String lifecycle,
      required DateTime createdAt,
      required DateTime updatedAt,
      required int sortOrder,
      Value<bool> isPinned,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$IdeasTableUpdateCompanionBuilder =
    IdeasCompanion Function({
      Value<String> id,
      Value<String> appId,
      Value<String?> groupId,
      Value<String> title,
      Value<String> body,
      Value<String> lifecycle,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> sortOrder,
      Value<bool> isPinned,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

final class $$IdeasTableReferences
    extends BaseReferences<_$AppDatabase, $IdeasTable, IdeaRow> {
  $$IdeasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AppsTable _appIdTable(_$AppDatabase db) =>
      db.apps.createAlias('ideas__app_id__apps__id');

  $$AppsTableProcessedTableManager get appId {
    final $_column = $_itemColumn<String>('app_id')!;

    final manager = $$AppsTableTableManager(
      $_db,
      $_db.apps,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IdeaGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.ideaGroups.createAlias('ideas__group_id__idea_groups__id');

  $$IdeaGroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $$IdeaGroupsTableTableManager(
      $_db,
      $_db.ideaGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ContentBlocksTable, List<ContentBlockRow>>
  _contentBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contentBlocks,
    aliasName: 'ideas__id__content_blocks__idea_id',
  );

  $$ContentBlocksTableProcessedTableManager get contentBlocksRefs {
    final manager = $$ContentBlocksTableTableManager(
      $_db,
      $_db.contentBlocks,
    ).filter((f) => f.ideaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contentBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IdeasTableFilterComposer extends Composer<_$AppDatabase, $IdeasTable> {
  $$IdeasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lifecycle => $composableBuilder(
    column: $table.lifecycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$AppsTableFilterComposer get appId {
    final $$AppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appId,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableFilterComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdeaGroupsTableFilterComposer get groupId {
    final $$IdeaGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.ideaGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeaGroupsTableFilterComposer(
            $db: $db,
            $table: $db.ideaGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> contentBlocksRefs(
    Expression<bool> Function($$ContentBlocksTableFilterComposer f) f,
  ) {
    final $$ContentBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentBlocks,
      getReferencedColumn: (t) => t.ideaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentBlocksTableFilterComposer(
            $db: $db,
            $table: $db.contentBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IdeasTableOrderingComposer
    extends Composer<_$AppDatabase, $IdeasTable> {
  $$IdeasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lifecycle => $composableBuilder(
    column: $table.lifecycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppsTableOrderingComposer get appId {
    final $$AppsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appId,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableOrderingComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdeaGroupsTableOrderingComposer get groupId {
    final $$IdeaGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.ideaGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeaGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.ideaGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdeasTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdeasTable> {
  $$IdeasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get lifecycle =>
      $composableBuilder(column: $table.lifecycle, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$AppsTableAnnotationComposer get appId {
    final $$AppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appId,
      referencedTable: $db.apps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppsTableAnnotationComposer(
            $db: $db,
            $table: $db.apps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IdeaGroupsTableAnnotationComposer get groupId {
    final $$IdeaGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.ideaGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeaGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.ideaGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> contentBlocksRefs<T extends Object>(
    Expression<T> Function($$ContentBlocksTableAnnotationComposer a) f,
  ) {
    final $$ContentBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentBlocks,
      getReferencedColumn: (t) => t.ideaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IdeasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdeasTable,
          IdeaRow,
          $$IdeasTableFilterComposer,
          $$IdeasTableOrderingComposer,
          $$IdeasTableAnnotationComposer,
          $$IdeasTableCreateCompanionBuilder,
          $$IdeasTableUpdateCompanionBuilder,
          (IdeaRow, $$IdeasTableReferences),
          IdeaRow,
          PrefetchHooks Function({
            bool appId,
            bool groupId,
            bool contentBlocksRefs,
          })
        > {
  $$IdeasTableTableManager(_$AppDatabase db, $IdeasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdeasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdeasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdeasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> appId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> lifecycle = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion(
                id: id,
                appId: appId,
                groupId: groupId,
                title: title,
                body: body,
                lifecycle: lifecycle,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isPinned: isPinned,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String appId,
                Value<String?> groupId = const Value.absent(),
                required String title,
                required String body,
                required String lifecycle,
                required DateTime createdAt,
                required DateTime updatedAt,
                required int sortOrder,
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion.insert(
                id: id,
                appId: appId,
                groupId: groupId,
                title: title,
                body: body,
                lifecycle: lifecycle,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isPinned: isPinned,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$IdeasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({appId = false, groupId = false, contentBlocksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contentBlocksRefs) db.contentBlocks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (appId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.appId,
                                    referencedTable: $$IdeasTableReferences
                                        ._appIdTable(db),
                                    referencedColumn: $$IdeasTableReferences
                                        ._appIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$IdeasTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$IdeasTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contentBlocksRefs)
                        await $_getPrefetchedData<
                          IdeaRow,
                          $IdeasTable,
                          ContentBlockRow
                        >(
                          currentTable: table,
                          referencedTable: $$IdeasTableReferences
                              ._contentBlocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IdeasTableReferences(
                                db,
                                table,
                                p0,
                              ).contentBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ideaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IdeasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdeasTable,
      IdeaRow,
      $$IdeasTableFilterComposer,
      $$IdeasTableOrderingComposer,
      $$IdeasTableAnnotationComposer,
      $$IdeasTableCreateCompanionBuilder,
      $$IdeasTableUpdateCompanionBuilder,
      (IdeaRow, $$IdeasTableReferences),
      IdeaRow,
      PrefetchHooks Function({bool appId, bool groupId, bool contentBlocksRefs})
    >;
typedef $$ContentBlocksTableCreateCompanionBuilder =
    ContentBlocksCompanion Function({
      required String id,
      required String ideaId,
      required String type,
      required int sortOrder,
      required String textContent,
      Value<String> metadataJson,
      Value<int> payloadVersion,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ContentBlocksTableUpdateCompanionBuilder =
    ContentBlocksCompanion Function({
      Value<String> id,
      Value<String> ideaId,
      Value<String> type,
      Value<int> sortOrder,
      Value<String> textContent,
      Value<String> metadataJson,
      Value<int> payloadVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

final class $$ContentBlocksTableReferences
    extends
        BaseReferences<_$AppDatabase, $ContentBlocksTable, ContentBlockRow> {
  $$ContentBlocksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IdeasTable _ideaIdTable(_$AppDatabase db) =>
      db.ideas.createAlias('content_blocks__idea_id__ideas__id');

  $$IdeasTableProcessedTableManager get ideaId {
    final $_column = $_itemColumn<String>('idea_id')!;

    final manager = $$IdeasTableTableManager(
      $_db,
      $_db.ideas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ideaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContentBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $ContentBlocksTable> {
  $$ContentBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$IdeasTableFilterComposer get ideaId {
    final $$IdeasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ideaId,
      referencedTable: $db.ideas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeasTableFilterComposer(
            $db: $db,
            $table: $db.ideas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentBlocksTable> {
  $$ContentBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$IdeasTableOrderingComposer get ideaId {
    final $$IdeasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ideaId,
      referencedTable: $db.ideas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeasTableOrderingComposer(
            $db: $db,
            $table: $db.ideas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentBlocksTable> {
  $$ContentBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$IdeasTableAnnotationComposer get ideaId {
    final $$IdeasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ideaId,
      referencedTable: $db.ideas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdeasTableAnnotationComposer(
            $db: $db,
            $table: $db.ideas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentBlocksTable,
          ContentBlockRow,
          $$ContentBlocksTableFilterComposer,
          $$ContentBlocksTableOrderingComposer,
          $$ContentBlocksTableAnnotationComposer,
          $$ContentBlocksTableCreateCompanionBuilder,
          $$ContentBlocksTableUpdateCompanionBuilder,
          (ContentBlockRow, $$ContentBlocksTableReferences),
          ContentBlockRow,
          PrefetchHooks Function({bool ideaId})
        > {
  $$ContentBlocksTableTableManager(_$AppDatabase db, $ContentBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ideaId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> textContent = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentBlocksCompanion(
                id: id,
                ideaId: ideaId,
                type: type,
                sortOrder: sortOrder,
                textContent: textContent,
                metadataJson: metadataJson,
                payloadVersion: payloadVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ideaId,
                required String type,
                required int sortOrder,
                required String textContent,
                Value<String> metadataJson = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentBlocksCompanion.insert(
                id: id,
                ideaId: ideaId,
                type: type,
                sortOrder: sortOrder,
                textContent: textContent,
                metadataJson: metadataJson,
                payloadVersion: payloadVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContentBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ideaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ideaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ideaId,
                                referencedTable: $$ContentBlocksTableReferences
                                    ._ideaIdTable(db),
                                referencedColumn: $$ContentBlocksTableReferences
                                    ._ideaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContentBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentBlocksTable,
      ContentBlockRow,
      $$ContentBlocksTableFilterComposer,
      $$ContentBlocksTableOrderingComposer,
      $$ContentBlocksTableAnnotationComposer,
      $$ContentBlocksTableCreateCompanionBuilder,
      $$ContentBlocksTableUpdateCompanionBuilder,
      (ContentBlockRow, $$ContentBlocksTableReferences),
      ContentBlockRow,
      PrefetchHooks Function({bool ideaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkspacesTableTableManager get workspaces =>
      $$WorkspacesTableTableManager(_db, _db.workspaces);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$AppsTableTableManager get apps => $$AppsTableTableManager(_db, _db.apps);
  $$IdeaGroupsTableTableManager get ideaGroups =>
      $$IdeaGroupsTableTableManager(_db, _db.ideaGroups);
  $$IdeasTableTableManager get ideas =>
      $$IdeasTableTableManager(_db, _db.ideas);
  $$ContentBlocksTableTableManager get contentBlocks =>
      $$ContentBlocksTableTableManager(_db, _db.contentBlocks);
}
