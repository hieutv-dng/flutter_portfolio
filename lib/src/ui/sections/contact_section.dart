import 'package:flutter/material.dart';

import '../widgets/section_container.dart';

/// Placeholder Contact section — Phase 3 adds the contact details and links.
/// Present now so the hero's "Contact" CTA and nav have a scroll target.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return SectionContainer(
      background: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Contact', style: text.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Ways to reach me arrive in the next phase.',
            style: text.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
