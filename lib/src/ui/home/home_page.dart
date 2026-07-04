import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';

/// Placeholder landing page.
///
/// Phase 2 replaces this with the scrolling multi-section shell (hero, about,
/// projects, experience, contact) and the navigation bar. For now it just
/// proves the app boots and reads from [kPortfolioData].
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Profile profile = kPortfolioData.profile;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(profile.name, style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(profile.role, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
