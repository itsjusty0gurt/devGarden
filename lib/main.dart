import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/preferences/shell_preferences.dart';
import 'presentation/shell/shell_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferencesStore = FileShellPreferencesStore.defaultStore();
  final initialPreferences = await preferencesStore.load();

  runApp(
    ProviderScope(
      overrides: [
        shellPreferencesStoreProvider.overrideWithValue(preferencesStore),
        initialShellPreferencesProvider.overrideWithValue(initialPreferences),
      ],
      child: const GardenApplication(),
    ),
  );
}
