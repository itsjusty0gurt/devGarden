class EntityId {
  const EntityId(this.value) : assert(value != '');

  final String value;

  @override
  bool operator ==(Object other) => other is EntityId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class Workspace {
  const Workspace({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });

  final EntityId id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isDeleted;
}

class Project {
  const Project({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });

  final EntityId id;
  final EntityId workspaceId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isDeleted;
}

class GardenApp {
  const GardenApp({
    required this.id,
    required this.projectId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });

  final EntityId id;
  final EntityId projectId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isDeleted;
}

enum IdeaLifecycle {
  idea,
  approved,
  planned,
  building,
  complete,
  rejected,
  archived,
}

class Idea {
  const Idea({
    required this.id,
    required this.appId,
    required this.title,
    required this.body,
    required this.lifecycle,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isPinned,
    required this.isDeleted,
  });

  final EntityId id;
  final EntityId appId;
  final String title;
  final String body;
  final IdeaLifecycle lifecycle;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isPinned;
  final bool isDeleted;

  Idea copyWith({
    String? title,
    String? body,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Idea(
      id: id,
      appId: appId,
      title: title ?? this.title,
      body: body ?? this.body,
      lifecycle: lifecycle,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder,
      isPinned: isPinned,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
