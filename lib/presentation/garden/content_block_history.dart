import '../../domain/models/entities.dart';

enum ContentBlockHistoryKind { text, structural }

class ContentBlockHistoryEntry {
  ContentBlockHistoryEntry({
    required this.before,
    required this.after,
    required this.beforeFocusId,
    required this.afterFocusId,
    required this.kind,
    required this.coalesceId,
    required this.recordedAt,
  });

  final List<ContentBlock> before;
  List<ContentBlock> after;
  final EntityId? beforeFocusId;
  EntityId? afterFocusId;
  final ContentBlockHistoryKind kind;
  final EntityId? coalesceId;
  DateTime recordedAt;
}

class ContentBlockHistory {
  ContentBlockHistory({this.limit = 100});

  final int limit;
  final List<ContentBlockHistoryEntry> _undo = [];
  final List<ContentBlockHistoryEntry> _redo = [];

  bool get canUndo => _undo.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;
  ContentBlockHistoryEntry? get nextUndo => _undo.lastOrNull;
  ContentBlockHistoryEntry? get nextRedo => _redo.lastOrNull;

  void clear() {
    _undo.clear();
    _redo.clear();
  }

  void record({
    required List<ContentBlock> before,
    required List<ContentBlock> after,
    required EntityId? beforeFocusId,
    required EntityId? afterFocusId,
    required ContentBlockHistoryKind kind,
    EntityId? coalesceId,
  }) {
    final now = DateTime.now();
    final last = _undo.lastOrNull;
    if (kind == ContentBlockHistoryKind.text &&
        last?.kind == ContentBlockHistoryKind.text &&
        last?.coalesceId == coalesceId &&
        now.difference(last!.recordedAt) < const Duration(milliseconds: 900)) {
      last.after = [...after];
      last.afterFocusId = afterFocusId;
      last.recordedAt = now;
    } else {
      _undo.add(
        ContentBlockHistoryEntry(
          before: [...before],
          after: [...after],
          beforeFocusId: beforeFocusId,
          afterFocusId: afterFocusId,
          kind: kind,
          coalesceId: coalesceId,
          recordedAt: now,
        ),
      );
      if (_undo.length > limit) _undo.removeAt(0);
    }
    _redo.clear();
  }

  void completeUndo(ContentBlockHistoryEntry entry) {
    if (!identical(_undo.lastOrNull, entry)) return;
    _undo.removeLast();
    _redo.add(entry);
  }

  void completeRedo(ContentBlockHistoryEntry entry) {
    if (!identical(_redo.lastOrNull, entry)) return;
    _redo.removeLast();
    _undo.add(entry);
  }
}
