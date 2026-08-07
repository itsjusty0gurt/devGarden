import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

enum ExplorerSide { left, right }

class ShellPreferences {
  const ShellPreferences({
    required this.explorerSide,
    required this.explorerWidth,
    required this.appearanceMode,
    required this.contentZoom,
  });

  static const defaults = ShellPreferences(
    explorerSide: ExplorerSide.left,
    explorerWidth: 260,
    appearanceMode: ThemeMode.system,
    contentZoom: 1,
  );

  final ExplorerSide explorerSide;
  final double explorerWidth;
  final ThemeMode appearanceMode;
  final double contentZoom;

  ShellPreferences copyWith({
    ExplorerSide? explorerSide,
    double? explorerWidth,
    ThemeMode? appearanceMode,
    double? contentZoom,
  }) {
    return ShellPreferences(
      explorerSide: explorerSide ?? this.explorerSide,
      explorerWidth: explorerWidth ?? this.explorerWidth,
      appearanceMode: appearanceMode ?? this.appearanceMode,
      contentZoom: contentZoom ?? this.contentZoom,
    );
  }

  Map<String, Object> toJson() => {
    'explorerSide': explorerSide.name,
    'explorerWidth': explorerWidth,
    'appearanceMode': appearanceMode.name,
    'contentZoom': contentZoom,
  };

  factory ShellPreferences.fromJson(Map<String, Object?> json) {
    final sideName = json['explorerSide'] as String?;
    final appearanceName = json['appearanceMode'] as String?;
    final width = (json['explorerWidth'] as num?)?.toDouble();
    final zoom = (json['contentZoom'] as num?)?.toDouble();

    return ShellPreferences(
      explorerSide: ExplorerSide.values.firstWhere(
        (value) => value.name == sideName,
        orElse: () => ShellPreferences.defaults.explorerSide,
      ),
      explorerWidth: (width ?? ShellPreferences.defaults.explorerWidth)
          .clamp(180, 420)
          .toDouble(),
      appearanceMode: ThemeMode.values.firstWhere(
        (value) => value.name == appearanceName,
        orElse: () => ShellPreferences.defaults.appearanceMode,
      ),
      contentZoom: (zoom ?? ShellPreferences.defaults.contentZoom)
          .clamp(0.8, 1.4)
          .toDouble(),
    );
  }
}

abstract interface class ShellPreferencesStore {
  Future<ShellPreferences> load();

  Future<void> save(ShellPreferences preferences);
}

class FileShellPreferencesStore implements ShellPreferencesStore {
  FileShellPreferencesStore(this.file);

  factory FileShellPreferencesStore.defaultStore() {
    final basePath =
        Platform.environment['APPDATA'] ?? Directory.systemTemp.path;
    final separator = Platform.pathSeparator;
    return FileShellPreferencesStore(
      File('$basePath${separator}devGarden${separator}shell-preferences.json'),
    );
  }

  final File file;

  @override
  Future<ShellPreferences> load() async {
    try {
      if (!await file.exists()) {
        return ShellPreferences.defaults;
      }
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, Object?>) {
        return ShellPreferences.defaults;
      }
      return ShellPreferences.fromJson(decoded);
    } on FormatException {
      return ShellPreferences.defaults;
    } on FileSystemException {
      return ShellPreferences.defaults;
    }
  }

  @override
  Future<void> save(ShellPreferences preferences) async {
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(preferences.toJson()), flush: true);
  }
}

class MemoryShellPreferencesStore implements ShellPreferencesStore {
  MemoryShellPreferencesStore([this.value = ShellPreferences.defaults]);

  ShellPreferences value;

  @override
  Future<ShellPreferences> load() async => value;

  @override
  Future<void> save(ShellPreferences preferences) async {
    value = preferences;
  }
}
