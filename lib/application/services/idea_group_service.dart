import '../../domain/models/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'hierarchy_service.dart';
import 'id_generator.dart';

class IdeaGroupService {
  const IdeaGroupService(this._groups, this._ideas, this._ids, this._clock);

  final IdeaGroupRepository _groups;
  final IdeaRepository _ideas;
  final IdGenerator _ids;
  final Clock _clock;

  Future<IdeaGroup> create(EntityId appId, String name, {int sortOrder = 0}) {
    final safeName = _validName(name);
    final now = _clock().toUtc();
    return _groups.create(
      IdeaGroup(
        id: _ids.next(),
        appId: appId,
        name: safeName,
        createdAt: now,
        updatedAt: now,
        sortOrder: sortOrder,
        isDeleted: false,
      ),
    );
  }

  Future<IdeaGroup> rename(EntityId id, String name) async {
    final group = await _activeGroup(id);
    return _groups.rename(group.id, _validName(name), _clock().toUtc());
  }

  Future<void> archive(EntityId id) async {
    await _activeGroup(id);
    await _groups.archiveAndUngroup(id, _clock().toUtc());
  }

  Future<Idea> assign(EntityId ideaId, EntityId? groupId) async {
    final idea = await _ideas.getById(ideaId);
    if (idea == null || idea.isDeleted) {
      throw StateError('The Idea is unavailable.');
    }
    if (groupId != null) {
      final group = await _activeGroup(groupId);
      if (group.appId != idea.appId) {
        throw StateError('An Idea can only move to a group in the same App.');
      }
    }
    return _ideas.assignToGroup(
      id: ideaId,
      groupId: groupId,
      updatedAt: _clock().toUtc(),
    );
  }

  Future<IdeaGroup> _activeGroup(EntityId id) async {
    final group = await _groups.getById(id);
    if (group == null || group.isDeleted) {
      throw StateError('The Idea Group is unavailable.');
    }
    return group;
  }

  String _validName(String name) {
    final value = name.trim();
    if (value.isEmpty) throw ArgumentError.value(name, 'name', 'Required');
    return value;
  }
}
