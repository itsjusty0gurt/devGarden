import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xff5f8d67);

  static final light = _build(Brightness.light);
  static final dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      visualDensity: VisualDensity.compact,
      dividerColor: scheme.outlineVariant,
      tooltipTheme: const TooltipThemeData(
        waitDuration: Duration(milliseconds: 400),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          visualDensity: VisualDensity.compact,
          backgroundColor: WidgetStatePropertyAll(scheme.surface),
        ),
      ),
    );
  }
}
