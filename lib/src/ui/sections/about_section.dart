import 'package:flutter/material.dart';

import '../widgets/section_container.dart';

/// Placeholder About section — Phase 3 fills in the bio and skills. Present now
/// so navigation and scroll-to work end to end.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('About', style: text.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Bio and skills arrive in the next phase.',
            style: text.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
