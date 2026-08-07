import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/shell/desktop_shell.dart';
import '../presentation/views/placeholder_views.dart';
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
            builder: (context, state) => const WelcomeView(),
          ),
          GoRoute(
            path: '/workspace',
            name: 'workspace',
            builder: (context, state) => const PlaceholderView(
              title: 'Workspace',
              message: 'Workspace content is not implemented yet.',
              icon: PlaceholderViewIcon.workspace,
            ),
          ),
          GoRoute(
            path: '/project',
            name: 'project',
            builder: (context, state) => const PlaceholderView(
              title: 'Project',
              message: 'Project content is not implemented yet.',
              icon: PlaceholderViewIcon.project,
            ),
          ),
          GoRoute(
            path: '/app',
            name: 'app',
            builder: (context, state) => const PlaceholderView(
              title: 'App',
              message: 'App content is not implemented yet.',
              icon: PlaceholderViewIcon.app,
            ),
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
