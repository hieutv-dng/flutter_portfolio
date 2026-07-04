import 'package:flutter/material.dart';
import 'package:flutter_portfolio/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [PortfolioApp] at a fixed logical [size] and settles the entrance and
/// reveal animations so tests start from a stable frame.
///
/// The device pixel ratio is pinned to 1 so [size] is also the logical size,
/// which drives the responsive breakpoints (desktop ≥1024, mobile <768). The
/// viewport and the session-global [PortfolioApp.themeMode] notifier are reset
/// both up front and via `addTearDown`, so one test's size or theme choice never
/// leaks into the next.
Future<void> pumpPortfolio(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  PortfolioApp.themeMode.value = ThemeMode.system;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(() => PortfolioApp.themeMode.value = ThemeMode.system);

  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle();
}
