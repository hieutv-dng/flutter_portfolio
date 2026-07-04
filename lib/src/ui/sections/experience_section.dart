import 'package:flutter/material.dart';

import '../widgets/section_container.dart';

/// Placeholder Experience section — Phase 3 builds the career timeline. Present
/// now so navigation and scroll-to work end to end.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Experience', style: text.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Career timeline arrives in the next phase.',
            style: text.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
