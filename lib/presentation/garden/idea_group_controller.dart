import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../application/services/idea_group_service.dart';
import '../../domain/models/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'hierarchy_controller.dart';

enum IdeaGroupFilter { all, ungrouped, group }

class IdeaGroupState {
  const IdeaGroupState({
    this.appId,
    this.groups = const [],
    this.filter = IdeaGroupFilter.all,
    this.selectedGroupId,
    this.isLoading = false,
    this.errorMessage,
  });

  final EntityId? appId;
  final List<IdeaGroup> groups;
  final IdeaGroupFilter filter;
  final EntityId? selectedGroupId;
  final bool isLoading;
  final String? errorMessage;

  IdeaGroupState copyWith({
    List<IdeaGroup>? groups,
    IdeaGroupFilter? filter,
    EntityId? selectedGroupId,
    bool clearSelectedGroup = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IdeaGroupState(
      appId: appId,
      groups: groups ?? this.groups,
      filter: filter ?? this.filter,
      selectedGroupId: clearSelectedGroup
          ? null
          : selectedGroupId ?? this.selectedGroupId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final ideaGroupControllerProvider =
    StateNotifierProvider<IdeaGroupController, IdeaGroupState>((ref) {
      final controller = IdeaGroupController(
        ref.watch(ideaGroupServiceProvider),
        ref.watch(ideaGroupRepositoryProvider),
      );
      ref.listen<EntityId?>(selectedAppIdProvider, (previous, next) {
        unawaited(controller.selectApp(next));
      }, fireImmediately: true);
      return controller;
    });

class IdeaGroupController extends StateNotifier<IdeaGroupState> {
  IdeaGroupController(this._service, this._repository)
    : super(const IdeaGroupState());

  final IdeaGroupService _service;
  final IdeaGroupRepository _repository;

  Future<void> selectApp(EntityId? appId) async {
    if (appId == null) {
      state = const IdeaGroupState();
      return;
    }
    state = IdeaGroupState(appId: appId, isLoading: true);
    await refresh();
  }

  Future<void> refresh() async {
    final appId = state.appId;
    if (appId == null) return;
    try {
      final groups = await _repository.listActiveByApp(appId);
      if (state.appId == appId) {
        state = state.copyWith(
          groups: groups,
          isLoading: false,
          clearError: true,
        );
      }
    } catch (error, stackTrace) {
      _report('Could not load Idea Groups.', error, stackTrace);
    }
  }

  Future<void> create(String name) async {
    final appId = state.appId;
    if (appId == null) throw StateError('Select an App first.');
    try {
      final group = await _service.create(
        appId,
        name,
        sortOrder: state.groups.length,
      );
      state = state.copyWith(
        groups: [...state.groups, group],
        filter: IdeaGroupFilter.group,
        selectedGroupId: group.id,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not create the Idea Group.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> rename(EntityId id, String name) async {
    try {
      final updated = await _service.rename(id, name);
      state = state.copyWith(
        groups: [
          for (final item in state.groups)
            if (item.id == id) updated else item,
        ],
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not rename the Idea Group.', error, stackTrace);
      rethrow;
    }
  }

  Future<void> archive(EntityId id) async {
    try {
      await _service.archive(id);
      state = state.copyWith(
        groups: state.groups.where((group) => group.id != id).toList(),
        filter: state.selectedGroupId == id
            ? IdeaGroupFilter.all
            : state.filter,
        clearSelectedGroup: state.selectedGroupId == id,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _report('Could not archive the Idea Group.', error, stackTrace);
      rethrow;
    }
  }

  void showAll() => state = state.copyWith(
    filter: IdeaGroupFilter.all,
    clearSelectedGroup: true,
  );

  void showUngrouped() => state = state.copyWith(
    filter: IdeaGroupFilter.ungrouped,
    clearSelectedGroup: true,
  );

  void showGroup(EntityId id) => state = state.copyWith(
    filter: IdeaGroupFilter.group,
    selectedGroupId: id,
  );

  void _report(String message, Object error, StackTrace stackTrace) {
    developer.log(
      message,
      name: 'devGarden.ideaGroups',
      error: error,
      stackTrace: stackTrace,
    );
    state = state.copyWith(isLoading: false, errorMessage: message);
  }
}
