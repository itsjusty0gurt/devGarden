import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/shell/desktop_shell.dart';
import '../presentation/garden/garden_home_view.dart';
import '../presentation/garden/idea_editor_view.dart';
import '../presentation/views/settings_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => DesktopShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'welcome',
            builder: (context, state) => const GardenHomeView(),
          ),
          GoRoute(
            path: '/workspace',
            name: 'workspace',
            builder: (context, state) => const GardenHomeView(),
          ),
          GoRoute(
            path: '/project',
            name: 'project',
            builder: (context, state) => const GardenHomeView(),
          ),
          GoRoute(
            path: '/app',
            name: 'app',
            builder: (context, state) => const GardenHomeView(),
          ),
          GoRoute(
            path: '/idea/:id',
            name: 'idea',
            builder: (context, state) =>
                IdeaEditorView(ideaId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsView(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
