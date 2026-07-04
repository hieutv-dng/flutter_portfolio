import 'package:flutter/material.dart';
import 'package:flutter_portfolio/src/data/portfolio_data.dart';
import 'package:flutter_portfolio/src/ui/sections/hero_section.dart';
import 'package:flutter_portfolio/src/ui/widgets/project_card.dart';
import 'package:flutter_portfolio/src/ui/widgets/section_heading.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_portfolio.dart';

void main() {
  testWidgets('renders all five sections and scrolls to the footer', (
    WidgetTester tester,
  ) async {
    await pumpPortfolio(tester);

    // The hero itself, plus its identity and the four titled section headings.
    expect(find.byType(HeroSection), findsOneWidget);
    expect(find.text('Hieu Tran'), findsWidgets);
    for (final String title in <String>[
      'About',
      'Projects',
      'Experience',
      'Contact',
    ]) {
      expect(
        find.descendant(
          of: find.byType(SectionHeading),
          matching: find.text(title),
        ),
        findsOneWidget,
      );
    }

    // The page scrolls end-to-end until the footer credit is visible.
    final Finder footer = find.text('© 2026 Hieu Tran · Built with Flutter');
    await tester.scrollUntilVisible(
      footer,
      400,
      scrollable: find
          .ancestor(of: footer, matching: find.byType(Scrollable))
          .first,
    );
    expect(footer, findsOneWidget);
  });

  testWidgets('projects grid renders one card per project', (
    WidgetTester tester,
  ) async {
    await pumpPortfolio(tester);

    expect(
      find.byType(ProjectCard),
      findsNWidgets(kPortfolioData.projects.length),
    );
  });
}
