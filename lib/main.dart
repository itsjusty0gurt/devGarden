import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/preferences/shell_preferences.dart';
import 'infrastructure/database/app_database.dart';
import 'presentation/shell/shell_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferencesStore = FileShellPreferencesStore.defaultStore();
  final initialPreferences = await preferencesStore.load();
  final database = AppDatabase.openDefault();

  runApp(
    ProviderScope(
      overrides: [
        shellPreferencesStoreProvider.overrideWithValue(preferencesStore),
        initialShellPreferencesProvider.overrideWithValue(initialPreferences),
        databaseProvider.overrideWithValue(database),
      ],
      child: const GardenApplication(),
    ),
  );
}
