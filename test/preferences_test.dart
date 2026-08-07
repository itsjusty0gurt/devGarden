import 'dart:io';

import 'package:dev_garden/core/preferences/shell_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('file preferences restore shell presentation state', () async {
    final directory = await Directory.systemTemp.createTemp(
      'dev_garden_preferences_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final store = FileShellPreferencesStore(
      File('${directory.path}${Platform.pathSeparator}preferences.json'),
    );
    const expected = ShellPreferences(
      explorerSide: ExplorerSide.right,
      explorerWidth: 318,
      appearanceMode: ThemeMode.dark,
      contentZoom: 1.2,
    );

    await store.save(expected);
    final restored = await store.load();

    expect(restored.explorerSide, ExplorerSide.right);
    expect(restored.explorerWidth, 318);
    expect(restored.appearanceMode, ThemeMode.dark);
    expect(restored.contentZoom, 1.2);
  });

  test('invalid preference content falls back to safe defaults', () async {
    final directory = await Directory.systemTemp.createTemp(
      'dev_garden_invalid_preferences_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File(
      '${directory.path}${Platform.pathSeparator}preferences.json',
    );
    await file.writeAsString('not json');
    final store = FileShellPreferencesStore(file);

    final restored = await store.load();

    expect(restored.explorerSide, ShellPreferences.defaults.explorerSide);
    expect(restored.explorerWidth, ShellPreferences.defaults.explorerWidth);
    expect(restored.appearanceMode, ShellPreferences.defaults.appearanceMode);
  });
}
