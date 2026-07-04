import 'package:flutter/material.dart';

/// Central Material 3 theme for the portfolio.
///
/// Change [_seedColor] in one place to re-tint the whole light and dark
/// palette. Themes are built once and cached in the static fields below.
abstract final class AppTheme {
  /// Temporary brand seed. Swap this when the final palette is chosen.
  static const Color _seedColor = Color(0xFF3D5AFE);

  /// Light theme derived from [_seedColor].
  static final ThemeData light = _build(Brightness.light);

  /// Dark theme derived from [_seedColor].
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    // Text theme stays on the bundled Roboto for now; a custom font can be
    // wired in later without touching call sites.
    return ThemeData(colorScheme: colorScheme);
  }
}
