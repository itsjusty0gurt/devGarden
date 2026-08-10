import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../application/services/content_block_service.dart';
import '../../domain/models/entities.dart';
import 'content_block_history.dart';

enum BlockSaveState { idle, saving, saved, failed }

class ContentBlockEditorState {
  const ContentBlockEditorState({
    this.ideaId,
    this.blocks = const [],
    this.activeBlockId,
    this.focusEpoch = 0,
    this.saveState = BlockSaveState.idle,
    this.isLoading = false,
    this.dirtyIds = const {},
    this.revisions = const {},
    this.slashBlockId,
    this.slashOptions = const [],
    this.slashSelection = 0,
    this.canUndo = false,
    this.canRedo = false,
    this.errorMessage,
  });

  final EntityId? ideaId;
  final List<ContentBlock> blocks;
  final EntityId? activeBlockId;
  final int focusEpoch;
  final BlockSaveState saveState;
  final bool isLoading;
  final Set<EntityId> dirtyIds;
  final Map<EntityId, int> revisions;
  final EntityId? slashBlockId;
  final List<BlockCommandOption> slashOptions;
  final int slashSelection;
  final bool canUndo;
  final bool canRedo;
  final String? errorMessage;

  String? get statusMessage => switch (saveState) {
    BlockSaveState.idle => null,
    BlockSaveState.saving => 'Savingâ€¦',
    BlockSaveState.saved => 'Saved',
    BlockSaveState.failed => 'Save failed',
  };

  ContentBlockEditorState copyWith({
    List<ContentBlock>? blocks,
    EntityId? activeBlockId,
    bool clearActive = false,
    int? focusEpoch,
    BlockSaveState? saveState,
    bool? isLoading,
    Set<EntityId>? dirtyIds,
    Map<EntityId, int>? revisions,
    EntityId? slashBlockId,
    bool clearSlash = false,
    List<BlockCommandOption>? slashOptions,
    int? slashSelection,
    bool? canUndo,
    bool? canRedo,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ContentBlockEditorState(
      ideaId: ideaId,
      blocks: blocks ?? this.blocks,
      activeBlockId: clearActive ? null : activeBlockId ?? this.activeBlockId,
      focusEpoch: focusEpoch ?? this.focusEpoch,
      saveState: saveState ?? this.saveState,
      isLoading: isLoading ?? this.isLoading,
      dirtyIds: dirtyIds ?? this.dirtyIds,
      revisions: revisions ?? this.revisions,
      slashBlockId: clearSlash ? null : slashBlockId ?? this.slashBlockId,
      slashOptions: clearSlash ? const [] : slashOptions ?? this.slashOptions,
      slashSelection: clearSlash ? 0 : slashSelection ?? this.slashSelection,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final contentBlockSessionCoordinatorProvider =
    StateNotifierProvider<ContentBlockSessionCoordinator, EntityId?>(
      (ref) => ContentBlockSessionCoordinator(),
    );

final contentBlockControllerProvider =
    StateNotifierProvider.family<
      ContentBlockController,
      ContentBlockEditorState,
      EntityId
    >((ref, ideaId) {
      final controller = ContentBlockController(
        ref.watch(contentBlockServiceProvider),
      );
      final sessions = ref.read(
        contentBlockSessionCoordinatorProvider.notifier,
      );
      sessions.register(ideaId, controller);
      ref.onDispose(() => sessions.unregister(ideaId, controller));
      return controller;
    });

class ContentBlockSessionCoordinator extends StateNotifier<EntityId?> {
  ContentBlockSessionCoordinator() : super(null);

  final Map<EntityId, ContentBlockController> _sessions = {};

  void register(EntityId ideaId, ContentBlockController controller) {
    _sessions[ideaId] = controller;
  }

  void unregister(EntityId ideaId, ContentBlockController controller) {
    if (identical(_sessions[ideaId], controller)) {
      _sessions.remove(ideaId);
      if (state == ideaId) state = null;
    }
  }

  void activate(EntityId ideaId) {
    if (_sessions.containsKey(ideaId) && state != ideaId) state = ideaId;
  }

  ContentBlockController? controllerFor(EntityId ideaId) => _sessions[ideaId];

  ContentBlockController? get activeController =>
      state == null ? null : _sessions[state];

  bool get hasSessions => _sessions.isNotEmpty;

  Future<void> flushAll() =>
      Future.wait(_sessions.values.map((controller) => controller.flush()));

  Future<void> prepareAllToLeave() => Future.wait(
    _sessions.values.map((controller) => controller.prepareToLeave()),
  );

  Future<void> undoActive() async {
    await activeController?.undo();
  }

  Future<void> redoActive() async {
    await activeController?.redo();
  }
}

class ContentBlockController extends StateNotifier<ContentBlockEditorState> {
  ContentBlockController(this._service)
    : super(const ContentBlockEditorState());

  final ContentBlockService _service;
  final ContentBlockHistory _history = ContentBlockHistory();
  Timer? _autosave;
  Future<void>? _flushFuture;

  Future<void> openIdea(
    EntityId ideaId, {
    bool requestInitialFocus = true,
  }) async {
    if (state.ideaId == ideaId && !state.isLoading) return;
    await prepareToLeave();
    _autosave?.cancel();
    _history.clear();
    state = ContentBlockEditorState(ideaId: ideaId, isLoading: true);
    try {
      var blocks = await _service.load(ideaId);
      if (blocks.isEmpty) {
        blocks = [
          await _service.create(
            ideaId,
            ContentBlockType.paragraph,
            sortOrder: 0,
          ),
        ];
      }
      if (state.ideaId == ideaId) {
        state = state.copyWith(
          blocks: blocks,
          activeBlockId: blocks.first.id,
          focusEpoch: requestInitialFocus
              ? state.focusEpoch + 1
              : state.focusEpoch,
          saveState: BlockSaveState.saved,
          isLoading: false,
          clearError: true,
        );
      }
    } catch (error, stackTrace) {
      _report('Could not load this Ideaâ€™s blocks.', error, stackTrace);
    }
  }

  void activate(EntityId id) {
    state = state.copyWith(activeBlockId: id);
  }

  void requestFocus(EntityId id) {
    if (!state.blocks.any((block) => block.id == id)) return;
    state = state.copyWith(activeBlockId: id, focusEpoch: state.focusEpoch + 1);
  }

  void focusRelative(EntityId id, int delta) {
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0) return;
    requestFocus(
      state.blocks[(index + delta).clamp(0, state.blocks.length - 1)].id,
    );
  }

  void focusFirst() {
    if (state.blocks.isNotEmpty) requestFocus(state.blocks.first.id);
  }

  void focusLast() {
    if (state.blocks.isNotEmpty) requestFocus(state.blocks.last.id);
  }

  void updateText(EntityId id, String text) {
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0 || state.blocks[index].text == text) return;
    final before = [...state.blocks];
    final block = state.blocks[index];
    final blocks = [...state.blocks];
    blocks[index] = block.copyWith(text: text);
    _record(before, blocks, id, ContentBlockHistoryKind.text, coalesceId: id);
    final revisions = {...state.revisions, id: (state.revisions[id] ?? 0) + 1};
    final isSlash =
        block.type == ContentBlockType.paragraph &&
        text.startsWith('/') &&
        !text.contains('\n') &&
        text.trimLeft() == text;
    final options = isSlash
        ? filterBlockCommands(text)
        : const <BlockCommandOption>[];
    state = state.copyWith(
      blocks: blocks,
      activeBlockId: id,
      dirtyIds: {...state.dirtyIds, id},
      revisions: revisions,
      saveState: BlockSaveState.saving,
      slashBlockId: isSlash && options.isNotEmpty ? id : null,
      slashOptions: options,
      slashSelection: 0,
      clearSlash: !isSlash || options.isEmpty,
      clearError: true,
    );
    _scheduleSave();
    final command =
        block.type == ContentBlockType.paragraph &&
            text.trim().startsWith('```')
        ? parseBlockInputCommand(text)
        : null;
    if (command != null) {
      unawaited(
        _applyCommand(
          id,
          command,
          expectedText: text,
          expectedRevision: revisions[id]!,
        ),
      );
    }
  }

  void updateMetadata(EntityId id, Map<String, Object?> metadata) {
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0 || _mapsEqual(state.blocks[index].metadata, metadata)) return;
    final before = [...state.blocks];
    final blocks = [...state.blocks];
    blocks[index] = blocks[index].copyWith(metadata: metadata);
    _record(before, blocks, id, ContentBlockHistoryKind.structural);
    state = state.copyWith(
      blocks: blocks,
      activeBlockId: id,
      dirtyIds: {...state.dirtyIds, id},
      revisions: {...state.revisions, id: (state.revisions[id] ?? 0) + 1},
      saveState: BlockSaveState.saving,
      clearError: true,
    );
    _scheduleSave();
  }

  Future<ContentBlock> add(
    ContentBlockType type, {
    EntityId? afterId,
    Map<String, Object?>? metadata,
  }) async {
    await flush();
    final ideaId = state.ideaId;
    if (ideaId == null) throw StateError('Open an Idea first.');
    final before = [...state.blocks];
    final insertionIndex = afterId == null
        ? state.blocks.length
        : state.blocks.indexWhere((block) => block.id == afterId) + 1;
    final safeIndex = insertionIndex.clamp(0, state.blocks.length);
    try {
      final created = await _service.create(
        ideaId,
        type,
        sortOrder: state.blocks.length,
        metadata: metadata,
      );
      final blocks = [...state.blocks]..insert(safeIndex, created);
      final ordered = await _persistOrder(blocks);
      _record(before, ordered, created.id, ContentBlockHistoryKind.structural);
      state = state.copyWith(
        blocks: ordered,
        activeBlockId: created.id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
        clearSlash: true,
        clearError: true,
      );
      return ordered[safeIndex];
    } catch (error, stackTrace) {
      _report('Could not add the block.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> changeType(EntityId id, ContentBlockType type) async {
    await flush();
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0 || state.blocks[index].type == type) return;
    final before = [...state.blocks];
    try {
      final updated = await _service.update(
        state.blocks[index],
        type: type,
        metadata: ContentBlockService.defaultMetadata(type),
      );
      final blocks = [...state.blocks];
      blocks[index] = updated;
      _record(before, blocks, id, ContentBlockHistoryKind.structural);
      state = state.copyWith(
        blocks: blocks,
        activeBlockId: id,
        focusEpoch: state.focusEpoch + 1,
        clearSlash: true,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not change the block type.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> toggleChecklist(EntityId id, bool checked) async {
    updateMetadata(id, {'checked': checked});
    await flush();
    requestFocus(id);
  }

  Future<void> move(EntityId id, int delta) async {
    await flush();
    final from = state.blocks.indexWhere((block) => block.id == id);
    if (state.ideaId == null || from < 0) return;
    final to = (from + delta).clamp(0, state.blocks.length - 1);
    if (to == from) return;
    final before = [...state.blocks];
    final blocks = [...state.blocks];
    final block = blocks.removeAt(from);
    blocks.insert(to, block);
    try {
      final ordered = await _persistOrder(blocks);
      _record(before, ordered, id, ContentBlockHistoryKind.structural);
      state = state.copyWith(
        blocks: ordered,
        activeBlockId: id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not move the block.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> delete(EntityId id) async {
    await flush();
    final index = state.blocks.indexWhere((block) => block.id == id);
    final ideaId = state.ideaId;
    if (index < 0 || ideaId == null) return;
    final before = [...state.blocks];
    try {
      await _service.softDelete(id);
      var blocks = [...state.blocks]..removeAt(index);
      if (blocks.isEmpty) {
        blocks = [
          await _service.create(
            ideaId,
            ContentBlockType.paragraph,
            sortOrder: 0,
          ),
        ];
      } else {
        blocks = await _persistOrder(blocks);
      }
      final focusId = blocks[(index - 1).clamp(0, blocks.length - 1)].id;
      _record(before, blocks, focusId, ContentBlockHistoryKind.structural);
      state = state.copyWith(
        blocks: blocks,
        activeBlockId: focusId,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
        clearSlash: true,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not delete the block.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> splitBlock(EntityId id, int cursorOffset) async {
    await flush();
    final index = state.blocks.indexWhere((block) => block.id == id);
    final ideaId = state.ideaId;
    if (index < 0 || ideaId == null) return;
    final current = state.blocks[index];
    final offset = cursorOffset.clamp(0, current.text.length);
    final before = [...state.blocks];
    final nextType = current.type == ContentBlockType.checklist
        ? ContentBlockType.checklist
        : ContentBlockType.paragraph;
    if (current.type == ContentBlockType.checklist && current.text.isEmpty) {
      await changeType(id, ContentBlockType.paragraph);
      return;
    }
    try {
      final first = await _service.update(
        current,
        text: current.text.substring(0, offset),
      );
      final second = await _service.create(
        ideaId,
        nextType,
        sortOrder: state.blocks.length,
        text: current.text.substring(offset),
      );
      final blocks = [...state.blocks];
      blocks[index] = first;
      blocks.insert(index + 1, second);
      final ordered = await _persistOrder(blocks);
      _record(before, ordered, second.id, ContentBlockHistoryKind.structural);
      state = state.copyWith(
        blocks: ordered,
        activeBlockId: second.id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not split the block.', error, stackTrace);
    }
  }

  Future<void> handleBackspace(EntityId id) async {
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0) return;
    final block = state.blocks[index];
    if (block.type == ContentBlockType.code) return;
    if (block.text.isEmpty) {
      await delete(id);
      return;
    }
    if (block.type == ContentBlockType.heading) {
      await changeType(id, ContentBlockType.paragraph);
      return;
    }
    if (block.type != ContentBlockType.paragraph || index == 0) return;
    final previous = state.blocks[index - 1];
    if (previous.type != ContentBlockType.paragraph) return;
    await flush();
    final before = [...state.blocks];
    try {
      final merged = await _service.update(
        previous,
        text: previous.text + block.text,
      );
      await _service.softDelete(block.id);
      final blocks = [...state.blocks];
      blocks[index - 1] = merged;
      blocks.removeAt(index);
      final ordered = await _persistOrder(blocks);
      _record(before, ordered, previous.id, ContentBlockHistoryKind.structural);
      state = state.copyWith(
        blocks: ordered,
        activeBlockId: previous.id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
      );
    } catch (error, stackTrace) {
      _report('Could not merge the blocks.', error, stackTrace);
    }
  }

  void moveSlashSelection(int delta) {
    if (state.slashOptions.isEmpty) return;
    state = state.copyWith(
      slashSelection: (state.slashSelection + delta).clamp(
        0,
        state.slashOptions.length - 1,
      ),
    );
  }

  void dismissSlashMenu() => state = state.copyWith(clearSlash: true);

  Future<void> executeSlashCommand(
    EntityId id, [
    BlockCommandOption? option,
  ]) async {
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0) return;
    final selected =
        option ??
        (state.slashOptions.isNotEmpty
            ? state.slashOptions[state.slashSelection.clamp(
                0,
                state.slashOptions.length - 1,
              )]
            : null);
    final command =
        selected?.result ?? parseBlockInputCommand(state.blocks[index].text);
    if (command == null) return;
    await _applyCommand(
      id,
      command,
      expectedText: state.blocks[index].text,
      expectedRevision: state.revisions[id] ?? 0,
    );
  }

  Future<void> undo() async {
    final entry = _history.nextUndo;
    if (entry == null) return;
    await flush();
    if (await _applySnapshot(entry.before, entry.beforeFocusId)) {
      _history.completeUndo(entry);
      _syncHistoryFlags();
    }
  }

  Future<void> redo() async {
    final entry = _history.nextRedo;
    if (entry == null) return;
    await flush();
    if (await _applySnapshot(entry.after, entry.afterFocusId)) {
      _history.completeRedo(entry);
      _syncHistoryFlags();
    }
  }

  Future<void> flush() async {
    _autosave?.cancel();
    while (state.dirtyIds.isNotEmpty) {
      final active = _flushFuture;
      if (active != null) {
        await active;
        continue;
      }
      final id = state.dirtyIds.first;
      _flushFuture = _saveSnapshot(id);
      try {
        await _flushFuture;
      } finally {
        _flushFuture = null;
      }
      if (state.saveState == BlockSaveState.failed) return;
    }
  }

  Future<void> prepareToLeave() async {
    await flush();
    if (state.blocks.length < 2) return;
    var firstTrailing = state.blocks.length;
    while (firstTrailing > 0) {
      final block = state.blocks[firstTrailing - 1];
      if (block.type != ContentBlockType.paragraph || block.text.isNotEmpty) {
        break;
      }
      firstTrailing--;
    }
    final removeCount = state.blocks.length - firstTrailing - 1;
    if (removeCount <= 0) return;
    for (final block in state.blocks.sublist(firstTrailing + 1)) {
      await _service.softDelete(block.id);
    }
    final remaining = state.blocks.sublist(0, firstTrailing + 1);
    state = state.copyWith(
      blocks: await _persistOrder(remaining),
      clearSlash: true,
    );
  }

  Future<void> _applyCommand(
    EntityId id,
    BlockInputCommand command, {
    required String expectedText,
    required int expectedRevision,
  }) async {
    await flush();
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0 ||
        state.blocks[index].text != expectedText ||
        state.revisions[id] != expectedRevision) {
      return;
    }
    final before = [...state.blocks];
    try {
      final updated = await _service.update(
        state.blocks[index],
        type: command.type,
        text: '',
        metadata: command.metadata,
      );
      final blocks = [...state.blocks];
      blocks[index] = updated;
      _record(before, blocks, id, ContentBlockHistoryKind.structural);
      state = state.copyWith(
        blocks: blocks,
        activeBlockId: id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
        clearSlash: true,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not apply the block command.', error, stackTrace);
    }
  }

  Future<List<ContentBlock>> _persistOrder(List<ContentBlock> blocks) async {
    final ideaId = state.ideaId;
    if (ideaId == null) return blocks;
    await _service.reorder(ideaId, blocks.map((block) => block.id).toList());
    return [
      for (var index = 0; index < blocks.length; index++)
        blocks[index].copyWith(sortOrder: index),
    ];
  }

  Future<bool> _applySnapshot(
    List<ContentBlock> target,
    EntityId? focusId,
  ) async {
    _autosave?.cancel();
    final currentById = {for (final block in state.blocks) block.id: block};
    final targetById = {for (final block in target) block.id: block};
    try {
      for (final block in state.blocks) {
        if (!targetById.containsKey(block.id)) {
          await _service.setDeleted(block.id, true);
        }
      }
      for (final block in target) {
        if (!currentById.containsKey(block.id)) {
          await _service.setDeleted(block.id, false);
        }
        await _service.update(
          block,
          type: block.type,
          text: block.text,
          metadata: block.metadata,
        );
      }
      final ordered = await _persistOrder(target);
      final safeFocus = ordered.any((block) => block.id == focusId)
          ? focusId
          : ordered.firstOrNull?.id;
      state = state.copyWith(
        blocks: ordered,
        activeBlockId: safeFocus,
        focusEpoch: state.focusEpoch + 1,
        dirtyIds: const {},
        saveState: BlockSaveState.saved,
        clearSlash: true,
        clearError: true,
      );
      return true;
    } catch (error, stackTrace) {
      _report('Could not apply editor history.', error, stackTrace);
      return false;
    }
  }

  Future<void> _saveSnapshot(EntityId id) async {
    final block = state.blocks.where((item) => item.id == id).firstOrNull;
    if (block == null || !state.dirtyIds.contains(id)) return;
    final revision = state.revisions[id] ?? 0;
    state = state.copyWith(saveState: BlockSaveState.saving, clearError: true);
    try {
      final updated = await _service.update(block);
      final currentIndex = state.blocks.indexWhere((item) => item.id == id);
      if (currentIndex < 0) return;
      final unchanged = (state.revisions[id] ?? 0) == revision;
      final blocks = [...state.blocks];
      if (unchanged) blocks[currentIndex] = updated;
      final dirtyIds = {...state.dirtyIds};
      if (unchanged) dirtyIds.remove(id);
      state = state.copyWith(
        blocks: blocks,
        dirtyIds: dirtyIds,
        saveState: dirtyIds.isEmpty
            ? BlockSaveState.saved
            : BlockSaveState.saving,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report(
        'Your block changes could not be saved. They remain in the editor.',
        error,
        stackTrace,
      );
      state = state.copyWith(saveState: BlockSaveState.failed);
    }
  }

  void _record(
    List<ContentBlock> before,
    List<ContentBlock> after,
    EntityId? focusId,
    ContentBlockHistoryKind kind, {
    EntityId? coalesceId,
  }) {
    _history.record(
      before: before,
      after: after,
      beforeFocusId: state.activeBlockId,
      afterFocusId: focusId,
      kind: kind,
      coalesceId: coalesceId,
    );
    _syncHistoryFlags();
  }

  void _syncHistoryFlags() {
    state = state.copyWith(
      canUndo: _history.canUndo,
      canRedo: _history.canRedo,
    );
  }

  void _scheduleSave() {
    _autosave?.cancel();
    _autosave = Timer(
      const Duration(milliseconds: 500),
      () => unawaited(flush()),
    );
  }

  void _report(String message, Object error, StackTrace stackTrace) {
    developer.log(
      message,
      name: 'devGarden.blocks',
      error: error,
      stackTrace: stackTrace,
    );
    state = state.copyWith(
      isLoading: false,
      saveState: BlockSaveState.failed,
      errorMessage: message,
    );
  }

  @override
  void dispose() {
    _autosave?.cancel();
    super.dispose();
  }
}

bool _mapsEqual(Map<String, Object?> left, Map<String, Object?> right) {
  if (left.length != right.length) return false;
  return left.entries.every((entry) => right[entry.key] == entry.value);
}
