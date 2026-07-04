// Smoke test: the portfolio app builds and renders without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_portfolio/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PortfolioApp renders a MaterialApp without exceptions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    // Proves the placeholder content actually reaches the UI:
    // kPortfolioData.profile.name is rendered by HomePage.
    expect(find.text('Hieu Tran'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
