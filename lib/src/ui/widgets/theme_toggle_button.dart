import 'package:flutter/material.dart';

/// Icon button that flips the app between light and dark themes.
///
/// Shared by the nav bar and the drawer so the toggle behaves identically in
/// both. The first tap resolves the current [ThemeMode.system] brightness from
/// the platform, then sets an explicit light/dark mode; later taps just flip.
/// The choice lives only for the session (Phase 1 chose not to persist it).
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({required this.themeMode, super.key});

  final ValueNotifier<ThemeMode> themeMode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (BuildContext context, ThemeMode mode, Widget? child) {
        final bool isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system =>
            MediaQuery.platformBrightnessOf(context) == Brightness.dark,
        };
        return IconButton(
          tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: () =>
              themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark,
        );
      },
    );
  }
}
