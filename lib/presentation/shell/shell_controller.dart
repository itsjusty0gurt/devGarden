import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/preferences/shell_preferences.dart';

const _defaultStatus = 'Ready';

class ShellState {
  const ShellState({
    required this.preferences,
    this.statusMessage = _defaultStatus,
  });

  final ShellPreferences preferences;
  final String statusMessage;

  ExplorerSide get explorerSide => preferences.explorerSide;
  double get explorerWidth => preferences.explorerWidth;
  ThemeMode get appearanceMode => preferences.appearanceMode;
  double get contentZoom => preferences.contentZoom;

  ShellState copyWith({ShellPreferences? preferences, String? statusMessage}) {
    return ShellState(
      preferences: preferences ?? this.preferences,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}

final shellPreferencesStoreProvider = Provider<ShellPreferencesStore>((ref) {
  throw UnimplementedError('A shell preferences store must be provided.');
});

final initialShellPreferencesProvider = Provider<ShellPreferences>(
  (ref) => ShellPreferences.defaults,
);

final shellControllerProvider =
    StateNotifierProvider<ShellController, ShellState>((ref) {
      return ShellController(
        ref.watch(shellPreferencesStoreProvider),
        initialPreferences: ref.watch(initialShellPreferencesProvider),
      );
    });

class ShellController extends StateNotifier<ShellState> {
  ShellController(this._store, {required ShellPreferences initialPreferences})
    : super(ShellState(preferences: initialPreferences));

  final ShellPreferencesStore _store;

  void setStatus(String message) {
    state = state.copyWith(statusMessage: message);
  }

  void setExplorerWidth(double width) {
    final clamped = width.clamp(180, 420).toDouble();
    state = state.copyWith(
      preferences: state.preferences.copyWith(explorerWidth: clamped),
    );
  }

  Future<void> persistExplorerWidth() => _store.save(state.preferences);

  Future<void> resetExplorerWidth() async {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        explorerWidth: ShellPreferences.defaults.explorerWidth,
      ),
    );
    await _store.save(state.preferences);
  }

  Future<void> setExplorerSide(ExplorerSide side) async {
    state = state.copyWith(
      preferences: state.preferences.copyWith(explorerSide: side),
    );
    await _store.save(state.preferences);
  }

  Future<void> setAppearanceMode(ThemeMode mode) async {
    state = state.copyWith(
      preferences: state.preferences.copyWith(appearanceMode: mode),
    );
    await _store.save(state.preferences);
  }

  Future<void> changeZoom(double delta) async {
    final next = (state.contentZoom + delta).clamp(0.8, 1.4).toDouble();
    state = state.copyWith(
      preferences: state.preferences.copyWith(contentZoom: next),
      statusMessage: 'Content zoom ${displayZoom(next)}',
    );
    await _store.save(state.preferences);
  }

  static String displayZoom(double zoom) => '${(zoom * 100).round()}%';

  void saveUnavailable() {
    setStatus('Save unavailable — no Idea is open.');
  }

  void placeholder(String action) {
    setStatus('$action is not implemented yet.');
  }

  void fireAndForget(Future<void> operation) {
    unawaited(operation);
  }
}
