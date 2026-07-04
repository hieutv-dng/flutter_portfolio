import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';
import '../../utils/breakpoints.dart';
import '../widgets/section_container.dart';
import '../widgets/section_heading.dart';

/// About section: a bio paragraph alongside skill chips grouped by category.
///
/// Desktop lays the bio and skills side by side; tablet and mobile stack them.
/// All content comes from [kPortfolioData] — the profile bio and skill groups.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Profile profile = kPortfolioData.profile;
    final List<SkillGroup> skills = kPortfolioData.skills;
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;
    final bool isDesktop = ScreenSize.of(context) == ScreenSize.desktop;

    final Widget bio = Text(
      profile.bio,
      style: text.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.6,
      ),
    );

    final Widget skillsView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < skills.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: 20),
          Text(
            skills[i].category,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final String skill in skills[i].skills)
                Chip(
                  label: Text(skill),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
        ],
      ],
    );

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeading(eyebrow: 'Get to know me', title: 'About'),
          const SizedBox(height: 32),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 3, child: bio),
                const SizedBox(width: 48),
                Expanded(flex: 2, child: skillsView),
              ],
            )
          else ...<Widget>[bio, const SizedBox(height: 32), skillsView],
        ],
      ),
    );
  }
}
