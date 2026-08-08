import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../application/services/content_block_service.dart';
import '../../domain/models/entities.dart';

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
  final String? errorMessage;

  String? get statusMessage => switch (saveState) {
    BlockSaveState.idle => null,
    BlockSaveState.saving => 'Saving…',
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
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final contentBlockControllerProvider =
    StateNotifierProvider<ContentBlockController, ContentBlockEditorState>(
      (ref) => ContentBlockController(ref.watch(contentBlockServiceProvider)),
    );

class ContentBlockController extends StateNotifier<ContentBlockEditorState> {
  ContentBlockController(this._service)
    : super(const ContentBlockEditorState());

  final ContentBlockService _service;
  Timer? _autosave;
  Future<void>? _flushFuture;

  Future<void> openIdea(EntityId ideaId) async {
    if (state.ideaId == ideaId && !state.isLoading) return;
    await flush();
    _autosave?.cancel();
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
          focusEpoch: state.focusEpoch + 1,
          saveState: BlockSaveState.saved,
          isLoading: false,
          clearError: true,
        );
      }
    } catch (error, stackTrace) {
      _report('Could not load this Idea’s blocks.', error, stackTrace);
    }
  }

  void activate(EntityId id) {
    state = state.copyWith(activeBlockId: id);
  }

  void updateText(EntityId id, String text) {
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0) return;
    final block = state.blocks[index];
    final command = block.type == ContentBlockType.paragraph
        ? parseBlockInputCommand(text)
        : null;
    final blocks = [...state.blocks];
    blocks[index] = block.copyWith(text: text);
    final dirtyIds = {...state.dirtyIds, id};
    final revisions = {...state.revisions, id: (state.revisions[id] ?? 0) + 1};
    state = state.copyWith(
      blocks: blocks,
      activeBlockId: id,
      dirtyIds: dirtyIds,
      revisions: revisions,
      saveState: BlockSaveState.saving,
      clearError: true,
    );
    _scheduleSave();
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
    if (index < 0) return;
    final blocks = [...state.blocks];
    blocks[index] = blocks[index].copyWith(metadata: metadata);
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
      await _service.reorder(ideaId, blocks.map((block) => block.id).toList());
      final ordered = [
        for (var index = 0; index < blocks.length; index++)
          blocks[index].copyWith(sortOrder: index),
      ];
      state = state.copyWith(
        blocks: ordered,
        activeBlockId: created.id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
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
    if (index < 0) return;
    try {
      final updated = await _service.update(
        state.blocks[index],
        type: type,
        metadata: ContentBlockService.defaultMetadata(type),
      );
      final blocks = [...state.blocks];
      blocks[index] = updated;
      state = state.copyWith(blocks: blocks, clearError: true);
    } catch (error, stackTrace) {
      _report('Could not change the block type.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> toggleChecklist(EntityId id, bool checked) async {
    updateMetadata(id, {'checked': checked});
    await flush();
  }

  Future<void> move(EntityId id, int delta) async {
    await flush();
    final ideaId = state.ideaId;
    final from = state.blocks.indexWhere((block) => block.id == id);
    if (ideaId == null || from < 0) return;
    final to = (from + delta).clamp(0, state.blocks.length - 1);
    if (to == from) return;
    final blocks = [...state.blocks];
    final block = blocks.removeAt(from);
    blocks.insert(to, block);
    try {
      await _service.reorder(ideaId, blocks.map((item) => item.id).toList());
      state = state.copyWith(
        blocks: [
          for (var index = 0; index < blocks.length; index++)
            blocks[index].copyWith(sortOrder: index),
        ],
        activeBlockId: id,
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
    if (index < 0) return;
    try {
      await _service.softDelete(id);
      final blocks = [...state.blocks]..removeAt(index);
      if (blocks.isEmpty) {
        state = state.copyWith(
          blocks: const [],
          clearActive: true,
          saveState: BlockSaveState.saved,
          clearError: true,
        );
        await add(ContentBlockType.paragraph);
        return;
      }
      final focusIndex = index.clamp(0, blocks.length - 1);
      state = state.copyWith(
        blocks: blocks,
        activeBlockId: blocks[focusIndex].id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not delete the block.', error, stackTrace);
      rethrow;
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

  Future<void> _applyCommand(
    EntityId id,
    BlockInputCommand command, {
    required String expectedText,
    required int expectedRevision,
  }) async {
    await flush();
    final index = state.blocks.indexWhere((block) => block.id == id);
    if (index < 0) return;
    if (state.blocks[index].text != expectedText ||
        state.revisions[id] != expectedRevision) {
      return;
    }
    try {
      final updated = await _service.update(
        state.blocks[index],
        type: command.type,
        text: '',
        metadata: command.metadata,
      );
      final blocks = [...state.blocks];
      blocks[index] = updated;
      state = state.copyWith(
        blocks: blocks,
        activeBlockId: id,
        focusEpoch: state.focusEpoch + 1,
        saveState: BlockSaveState.saved,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not apply the block command.', error, stackTrace);
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

  void _scheduleSave() {
    _autosave?.cancel();
    _autosave = Timer(const Duration(milliseconds: 500), () {
      unawaited(flush());
    });
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
