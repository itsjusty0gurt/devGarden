import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/services/hierarchy_service.dart';
import '../application/services/id_generator.dart';
import '../application/services/idea_service.dart';
import '../domain/repositories/repositories.dart';
import '../infrastructure/database/app_database.dart';
import '../infrastructure/repositories/drift_repositories.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('An application database must be provided.');
});

final workspaceRepositoryProvider = Provider<WorkspaceRepository>(
  (ref) => DriftWorkspaceRepository(ref.watch(databaseProvider)),
);
final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => DriftProjectRepository(ref.watch(databaseProvider)),
);
final appRepositoryProvider = Provider<AppRepository>(
  (ref) => DriftAppRepository(ref.watch(databaseProvider)),
);
final ideaRepositoryProvider = Provider<IdeaRepository>(
  (ref) => DriftIdeaRepository(ref.watch(databaseProvider)),
);

final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => const UuidV7IdGenerator(),
);
final clockProvider = Provider<Clock>((ref) => DateTime.now);

final hierarchyServiceProvider = Provider<HierarchyService>(
  (ref) => HierarchyService(
    ref.watch(workspaceRepositoryProvider),
    ref.watch(projectRepositoryProvider),
    ref.watch(appRepositoryProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  ),
);

final ideaServiceProvider = Provider<IdeaService>(
  (ref) => IdeaService(
    ref.watch(ideaRepositoryProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(clockProvider),
  ),
);
