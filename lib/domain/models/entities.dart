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

class IdeaGroup {
  const IdeaGroup({
    required this.id,
    required this.appId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isDeleted,
  });

  final EntityId id;
  final EntityId appId;
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

enum ContentBlockType {
  paragraph,
  heading,
  code,
  checklist,
  bulletList,
  numberedList,
  quote,
  divider,
}

class ContentBlock {
  const ContentBlock({
    required this.id,
    required this.ideaId,
    required this.type,
    required this.sortOrder,
    required this.text,
    required this.metadata,
    required this.payloadVersion,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  final EntityId id;
  final EntityId ideaId;
  final ContentBlockType type;
  final int sortOrder;
  final String text;
  final Map<String, Object?> metadata;
  final int payloadVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  int get headingLevel => (metadata['level'] as num?)?.toInt() ?? 1;
  String get codeLanguage => metadata['language'] as String? ?? 'plainText';
  bool get isChecked => metadata['checked'] as bool? ?? false;

  ContentBlock copyWith({
    ContentBlockType? type,
    int? sortOrder,
    String? text,
    Map<String, Object?>? metadata,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return ContentBlock(
      id: id,
      ideaId: ideaId,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
      text: text ?? this.text,
      metadata: metadata ?? this.metadata,
      payloadVersion: payloadVersion,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
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
    this.groupId,
  });

  final EntityId id;
  final EntityId appId;
  final EntityId? groupId;
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
    EntityId? groupId,
    bool clearGroup = false,
  }) {
    return Idea(
      id: id,
      appId: appId,
      groupId: clearGroup ? null : groupId ?? this.groupId,
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
