import 'package:flutter/material.dart';

import '../widgets/section_container.dart';

/// Placeholder Projects section — Phase 3 renders the project cards. Present now
/// so navigation and scroll-to work end to end.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return SectionContainer(
      background: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Projects', style: text.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Selected work lands in the next phase.',
            style: text.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
