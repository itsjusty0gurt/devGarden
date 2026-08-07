import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../presentation/shell/shell_controller.dart';
import 'router.dart';

class GardenApplication extends ConsumerWidget {
  const GardenApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(
      shellControllerProvider.select((state) => state.appearanceMode),
    );

    return MaterialApp.router(
      title: 'devGarden',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
