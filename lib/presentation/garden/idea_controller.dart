import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../application/services/idea_service.dart';
import '../../application/services/idea_group_service.dart';
import '../../domain/models/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'hierarchy_controller.dart';

enum IdeaSaveState { idle, saving, saved, failed }

class IdeaState {
  const IdeaState({
    this.appId,
    this.ideas = const [],
    this.current,
    this.draftTitle = '',
    this.searchQuery = '',
    this.saveState = IdeaSaveState.idle,
    this.isLoading = false,
    this.isDirty = false,
    this.revision = 0,
    this.errorMessage,
  });

  final EntityId? appId;
  final List<Idea> ideas;
  final Idea? current;
  final String draftTitle;
  final String searchQuery;
  final IdeaSaveState saveState;
  final bool isLoading;
  final bool isDirty;
  final int revision;
  final String? errorMessage;

  String? get statusMessage => switch (saveState) {
    IdeaSaveState.idle => null,
    IdeaSaveState.saving => 'Saving…',
    IdeaSaveState.saved => 'Saved',
    IdeaSaveState.failed => 'Save failed',
  };

  IdeaState copyWith({
    EntityId? appId,
    bool clearApp = false,
    List<Idea>? ideas,
    Idea? current,
    bool clearCurrent = false,
    String? draftTitle,
    String? searchQuery,
    IdeaSaveState? saveState,
    bool? isLoading,
    bool? isDirty,
    int? revision,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IdeaState(
      appId: clearApp ? null : appId ?? this.appId,
      ideas: ideas ?? this.ideas,
      current: clearCurrent ? null : current ?? this.current,
      draftTitle: draftTitle ?? this.draftTitle,
      searchQuery: searchQuery ?? this.searchQuery,
      saveState: saveState ?? this.saveState,
      isLoading: isLoading ?? this.isLoading,
      isDirty: isDirty ?? this.isDirty,
      revision: revision ?? this.revision,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final ideaControllerProvider = StateNotifierProvider<IdeaController, IdeaState>(
  (ref) {
    final controller = IdeaController(
      ref.watch(ideaServiceProvider),
      ref.watch(ideaGroupServiceProvider),
      ref.watch(ideaRepositoryProvider),
    );
    ref.listen<EntityId?>(selectedAppIdProvider, (previous, next) {
      unawaited(controller.selectApp(next));
    }, fireImmediately: true);
    return controller;
  },
);

class IdeaController extends StateNotifier<IdeaState> {
  IdeaController(this._service, this._groups, this._repository)
    : super(const IdeaState());

  final IdeaService _service;
  final IdeaGroupService _groups;
  final IdeaRepository _repository;
  Timer? _autosave;
  Future<void>? _flushFuture;
  int _searchEpoch = 0;

  Future<void> selectApp(EntityId? appId) async {
    if (state.appId == appId && !state.isLoading) return;
    await flush();
    _autosave?.cancel();
    if (appId == null) {
      state = const IdeaState();
      return;
    }
    state = IdeaState(appId: appId, isLoading: true);
    await _loadIdeas(appId);
  }

  Future<void> refresh() async {
    final appId = state.appId;
    if (appId != null) await _loadIdeas(appId);
  }

  Future<Idea> capture() async {
    final appId = state.appId;
    if (appId == null) {
      throw StateError('Select or create an App before capturing an Idea.');
    }
    try {
      final idea = await _service.capture(appId, sortOrder: state.ideas.length);
      state = state.copyWith(
        ideas: [idea, ...state.ideas],
        current: idea,
        draftTitle: idea.title,
        saveState: IdeaSaveState.saved,
        isDirty: false,
        clearError: true,
      );
      return idea;
    } catch (error, stackTrace) {
      _report('Could not create the Idea.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> open(EntityId id) async {
    if (state.current?.id == id) return;
    await flush();
    try {
      final idea = await _repository.getById(id);
      if (idea == null || idea.isDeleted) {
        throw StateError('The Idea is unavailable.');
      }
      state = state.copyWith(
        appId: idea.appId,
        current: idea,
        draftTitle: idea.title,
        saveState: IdeaSaveState.saved,
        isDirty: false,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not open the Idea.', error, stackTrace);
    }
  }

  void updateDraftTitle(String title) {
    if (state.current == null) return;
    state = state.copyWith(
      draftTitle: title,
      saveState: IdeaSaveState.saving,
      isDirty: true,
      revision: state.revision + 1,
      clearError: true,
    );
    _autosave?.cancel();
    _autosave = Timer(const Duration(milliseconds: 500), () {
      unawaited(flush());
    });
  }

  Future<void> flush() async {
    _autosave?.cancel();
    while (state.current != null && state.isDirty) {
      final active = _flushFuture;
      if (active != null) {
        await active;
        continue;
      }
      _flushFuture = _saveSnapshot();
      try {
        await _flushFuture;
      } finally {
        _flushFuture = null;
      }
      if (state.saveState == IdeaSaveState.failed) return;
    }
  }

  Future<void> search(String query) async {
    final appId = state.appId;
    if (appId == null) return;
    final epoch = ++_searchEpoch;
    state = state.copyWith(
      searchQuery: query,
      isLoading: true,
      clearError: true,
    );
    try {
      final ideas = await _service.search(appId, query);
      if (epoch == _searchEpoch) {
        state = state.copyWith(ideas: ideas, isLoading: false);
      }
    } catch (error, stackTrace) {
      if (epoch == _searchEpoch) {
        _report('Search failed. Try again.', error, stackTrace);
      }
    }
  }

  Future<void> softDelete(EntityId id) async {
    if (state.current?.id == id) await flush();
    try {
      await _service.softDelete(id);
      state = state.copyWith(
        ideas: state.ideas.where((idea) => idea.id != id).toList(),
        clearCurrent: state.current?.id == id,
        draftTitle: state.current?.id == id ? '' : state.draftTitle,
        saveState: IdeaSaveState.idle,
        isDirty: false,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not archive the Idea.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> moveToGroup(EntityId id, EntityId? groupId) async {
    if (state.current?.id == id) await flush();
    try {
      final updated = await _groups.assign(id, groupId);
      state = state.copyWith(
        ideas: [
          for (final item in state.ideas)
            if (item.id == id) updated else item,
        ],
        current: state.current?.id == id ? updated : state.current,
        saveState: state.current?.id == id
            ? IdeaSaveState.saved
            : state.saveState,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not move the Idea.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> _loadIdeas(EntityId appId) async {
    try {
      final ideas = await _repository.listActiveByApp(appId);
      if (state.appId == appId) {
        state = state.copyWith(
          ideas: ideas,
          isLoading: false,
          clearError: true,
        );
      }
    } catch (error, stackTrace) {
      _report('Could not load Ideas.', error, stackTrace);
    }
  }

  Future<void> _saveSnapshot() async {
    final idea = state.current;
    if (idea == null || !state.isDirty) return;
    final revision = state.revision;
    final title = state.draftTitle;
    state = state.copyWith(saveState: IdeaSaveState.saving, clearError: true);
    try {
      final updated = await _service.updateTitle(idea.id, title);
      if (state.current?.id != idea.id) return;
      final ideas = [
        for (final item in state.ideas)
          if (item.id == updated.id) updated else item,
      ];
      final unchanged = state.revision == revision;
      state = state.copyWith(
        ideas: ideas,
        current: updated,
        saveState: unchanged ? IdeaSaveState.saved : IdeaSaveState.saving,
        isDirty: !unchanged,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report(
        'Your changes could not be saved. They remain in the editor.',
        error,
        stackTrace,
      );
      state = state.copyWith(saveState: IdeaSaveState.failed, isDirty: true);
    }
  }

  void _report(String message, Object error, StackTrace stackTrace) {
    developer.log(
      message,
      name: 'devGarden.ideas',
      error: error,
      stackTrace: stackTrace,
    );
    state = state.copyWith(isLoading: false, errorMessage: message);
  }

  @override
  void dispose() {
    _autosave?.cancel();
    super.dispose();
  }
}
