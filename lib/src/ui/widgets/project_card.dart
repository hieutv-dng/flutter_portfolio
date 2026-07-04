import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';
import '../../utils/open_external_link.dart';

/// A single project rendered as a bordered card: title, a description clamped to
/// three lines, tag chips, and — when [Project.url] is set — a trailing button
/// that opens the repo or demo in a new tab.
///
/// The card sizes to its own content; the projects grid gives it a fixed width
/// per column, so rows keep a natural (unequal) height without overflowing.
class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;
    final ColorScheme colors = theme.colorScheme;
    final String? url = project.url;

    return Card(
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    project.title,
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (url != null)
                  IconButton(
                    tooltip: 'Open ${project.title}',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.open_in_new_rounded, size: 20),
                    onPressed: () => openExternalLink(url),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final String tag in project.tags)
                  Chip(
                    label: Text(tag),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
