import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'ui/home/home_page.dart';

/// Root widget for the portfolio application.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  /// App-wide theme mode. Defaults to following the system setting; the
  /// navigation bar toggle (Phase 2) flips this notifier and the app rebuilds.
  /// Session-only — the choice is intentionally not persisted.
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      // HomePage is passed as the pre-built child so it is not rebuilt when
      // only the theme mode changes.
      child: const HomePage(),
      builder: (BuildContext context, ThemeMode mode, Widget? child) {
        return MaterialApp(
          title: 'Hieu Tran',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: child,
        );
      },
    );
  }
}
