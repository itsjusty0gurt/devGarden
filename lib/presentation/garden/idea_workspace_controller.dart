import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/entities.dart';

class IdeaWorkspaceState {
  const IdeaWorkspaceState({
    this.expandedIdeaIds = const {},
    this.revealIdeaId,
  });

  final Set<EntityId> expandedIdeaIds;
  final EntityId? revealIdeaId;

  bool isExpanded(EntityId id) => expandedIdeaIds.contains(id);

  IdeaWorkspaceState copyWith({
    Set<EntityId>? expandedIdeaIds,
    EntityId? revealIdeaId,
    bool clearReveal = false,
  }) {
    return IdeaWorkspaceState(
      expandedIdeaIds: expandedIdeaIds ?? this.expandedIdeaIds,
      revealIdeaId: clearReveal ? null : revealIdeaId ?? this.revealIdeaId,
    );
  }
}

final ideaWorkspaceControllerProvider =
    StateNotifierProvider<IdeaWorkspaceController, IdeaWorkspaceState>(
      (ref) => IdeaWorkspaceController(),
    );

class IdeaWorkspaceController extends StateNotifier<IdeaWorkspaceState> {
  IdeaWorkspaceController() : super(const IdeaWorkspaceState());

  void expand(EntityId id) {
    state = state.copyWith(expandedIdeaIds: {...state.expandedIdeaIds, id});
  }

  void collapse(EntityId id) {
    state = state.copyWith(
      expandedIdeaIds: {...state.expandedIdeaIds}..remove(id),
    );
  }

  void toggle(EntityId id) {
    if (state.isExpanded(id)) {
      collapse(id);
    } else {
      expand(id);
    }
  }

  void reveal(EntityId id) {
    state = state.copyWith(
      expandedIdeaIds: {...state.expandedIdeaIds, id},
      revealIdeaId: id,
    );
  }

  void ensureInitial(EntityId id) {
    if (state.expandedIdeaIds.isEmpty) expand(id);
  }

  void consumeReveal(EntityId id) {
    if (state.revealIdeaId == id) state = state.copyWith(clearReveal: true);
  }

  void remove(EntityId id) {
    final expanded = {...state.expandedIdeaIds}..remove(id);
    state = state.copyWith(
      expandedIdeaIds: expanded,
      clearReveal: state.revealIdeaId == id,
    );
  }
}
