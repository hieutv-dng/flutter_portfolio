import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';
import '../../utils/open_external_link.dart';
import '../widgets/section_container.dart';
import '../widgets/section_heading.dart';
import '../widgets/social_icon_button.dart';

/// Contact section and page footer: a prompt, a `mailto:` button, the social
/// row, and a closing credit line. All addresses come from [kPortfolioData].
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Profile profile = kPortfolioData.profile;
    final List<SocialLink> socials = kPortfolioData.socials;
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;
    final ColorScheme colors = theme.colorScheme;

    return SectionContainer(
      background: colors.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeading(eyebrow: "Let's talk", title: 'Contact'),
          const SizedBox(height: 16),
          Text(
            "Have a project in mind or just want to say hi? "
            "Reach out and I'll get back to you.",
            style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: () => openExternalLink('mailto:${profile.email}'),
              icon: const Icon(Icons.email_outlined),
              label: Text(profile.email),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            children: <Widget>[
              for (final SocialLink link in socials)
                SocialIconButton(link: link),
            ],
          ),
          const SizedBox(height: 40),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '© 2026 ${profile.name} · Built with Flutter',
              style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
