import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';
import '../../utils/breakpoints.dart';
import '../widgets/project_card.dart';
import '../widgets/section_container.dart';
import '../widgets/section_heading.dart';

/// Projects section: a responsive grid of [ProjectCard]s — three columns on
/// desktop, two on tablet, one on mobile.
///
/// The grid is a [Wrap] of fixed-width cards (width computed from the available
/// space and column count) rather than a nested [GridView], so it never embeds a
/// scrollable inside the page's outer scroll view.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  /// Horizontal and vertical space between cards.
  static const double _gap = 24;

  @override
  Widget build(BuildContext context) {
    final List<Project> projects = kPortfolioData.projects;
    final int columns = switch (ScreenSize.of(context)) {
      ScreenSize.mobile => 1,
      ScreenSize.tablet => 2,
      ScreenSize.desktop => 3,
    };

    return SectionContainer(
      background: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeading(eyebrow: "Things I've built", title: 'Projects'),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Floor the width so accumulated fractional pixels never push a
              // row past the available space and collapse the column count.
              final double itemWidth = columns == 1
                  ? constraints.maxWidth
                  : ((constraints.maxWidth - _gap * (columns - 1)) / columns)
                        .floorToDouble();
              return Wrap(
                spacing: _gap,
                runSpacing: _gap,
                children: <Widget>[
                  for (final Project project in projects)
                    SizedBox(
                      width: itemWidth,
                      child: ProjectCard(project: project),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
