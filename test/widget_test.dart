// Smoke test: the portfolio app builds and renders without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_portfolio/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PortfolioApp builds the home shell without exceptions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    // The profile name reaches the UI via both the nav bar and the hero, so it
    // appears more than once.
    expect(find.text('Hieu Tran'), findsWidgets);
    // A section heading proves the scrollable body rendered.
    expect(find.text('About'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
