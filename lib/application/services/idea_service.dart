import '../../domain/models/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'hierarchy_service.dart';
import 'id_generator.dart';

class IdeaService {
  const IdeaService(this._ideas, this._ids, this._clock);

  final IdeaRepository _ideas;
  final IdGenerator _ids;
  final Clock _clock;

  Future<Idea> capture(EntityId appId, {int sortOrder = 0}) {
    final now = _clock().toUtc();
    return _ideas.create(
      Idea(
        id: _ids.next(),
        appId: appId,
        groupId: null,
        title: 'Untitled Idea',
        body: '',
        lifecycle: IdeaLifecycle.idea,
        createdAt: now,
        updatedAt: now,
        sortOrder: sortOrder,
        isPinned: false,
        isDeleted: false,
      ),
    );
  }

  Future<Idea> update(EntityId id, String title, String body) {
    final safeTitle = title.trim().isEmpty ? 'Untitled Idea' : title.trim();
    return _ideas.updateContent(
      id: id,
      title: safeTitle,
      body: body,
      updatedAt: _clock().toUtc(),
    );
  }

  Future<List<Idea>> search(EntityId appId, String query) {
    final trimmed = query.trim();
    return trimmed.isEmpty
        ? _ideas.listActiveByApp(appId)
        : _ideas.search(appId, trimmed);
  }

  Future<void> softDelete(EntityId id) {
    return _ideas.softDelete(id, _clock().toUtc());
  }
}
