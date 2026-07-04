import 'package:flutter/material.dart';
import 'package:flutter_portfolio/src/app.dart';
import 'package:flutter_portfolio/src/ui/widgets/nav_drawer.dart';
import 'package:flutter_portfolio/src/ui/widgets/section_heading.dart';
import 'package:flutter_portfolio/src/ui/widgets/theme_toggle_button.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_portfolio.dart';

/// The Projects section heading — the title `Text` inside a [SectionHeading],
/// which excludes the identically-labelled nav entry.
final Finder _projectsHeading = find.descendant(
  of: find.byType(SectionHeading),
  matching: find.text('Projects'),
);

void main() {
  testWidgets('builds the home shell without exceptions', (
    WidgetTester tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.byType(MaterialApp), findsOneWidget);
    // The profile name reaches the UI via both the nav bar and the hero.
    expect(find.text('Hieu Tran'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'desktop shows inline nav links, no hamburger, and scrolls on tap',
    (WidgetTester tester) async {
      await pumpPortfolio(tester, size: const Size(1440, 900));

      // Every section (bar the hero) is an inline text link; no menu button.
      for (final String label in <String>[
        'About',
        'Projects',
        'Experience',
        'Contact',
      ]) {
        expect(find.widgetWithText(TextButton, label), findsOneWidget);
      }
      expect(find.widgetWithIcon(IconButton, Icons.menu), findsNothing);

      // Projects starts below the fold, then scrolls into view when its link is
      // tapped.
      expect(tester.getTopLeft(_projectsHeading).dy, greaterThan(900));
      await tester.tap(find.widgetWithText(TextButton, 'Projects'));
      await tester.pumpAndSettle();

      final double dy = tester.getTopLeft(_projectsHeading).dy;
      expect(dy, greaterThanOrEqualTo(0));
      expect(dy, lessThan(900));
    },
  );

  testWidgets(
    'mobile hamburger opens the drawer; tapping a link closes it and scrolls',
    (WidgetTester tester) async {
      await pumpPortfolio(tester, size: const Size(390, 844));

      final ScaffoldState scaffold = tester.state(find.byType(Scaffold));
      expect(scaffold.isEndDrawerOpen, isFalse);
      expect(find.widgetWithText(TextButton, 'Projects'), findsNothing);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.menu));
      await tester.pumpAndSettle();
      expect(scaffold.isEndDrawerOpen, isTrue);
      expect(find.byType(NavDrawer), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, 'Projects'));
      await tester.pumpAndSettle();
      expect(scaffold.isEndDrawerOpen, isFalse);

      final double dy = tester.getTopLeft(_projectsHeading).dy;
      expect(dy, greaterThanOrEqualTo(0));
      expect(dy, lessThan(844));
    },
  );

  testWidgets('theme toggle flips the app off system mode', (
    WidgetTester tester,
  ) async {
    await pumpPortfolio(tester, size: const Size(1440, 900));
    expect(PortfolioApp.themeMode.value, ThemeMode.system);

    await tester.tap(
      find.descendant(
        of: find.byType(ThemeToggleButton),
        matching: find.byType(IconButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(PortfolioApp.themeMode.value, isNot(ThemeMode.system));
  });
}
