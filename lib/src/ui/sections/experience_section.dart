import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';
import '../widgets/experience_tile.dart';
import '../widgets/section_container.dart';
import '../widgets/section_heading.dart';

/// Experience section: a vertical timeline of work history built from
/// [kPortfolioData]'s experiences, most recent first.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Experience> experiences = kPortfolioData.experiences;
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeading(
            eyebrow: "Where I've worked",
            title: 'Experience',
          ),
          const SizedBox(height: 32),
          for (int i = 0; i < experiences.length; i++)
            ExperienceTile(
              experience: experiences[i],
              isLast: i == experiences.length - 1,
            ),
        ],
      ),
    );
  }
}
