import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';
import '../../utils/open_external_link.dart';

/// A single project rendered as a bordered card: title, a description clamped to
/// three lines, tag chips, and — when [Project.url] is set — a trailing button
/// that opens the repo or demo in a new tab.
///
/// On pointer devices, hovering lifts the card slightly (scale 1.02) and swaps
/// its border to the theme accent. The card sizes to its own content; the
/// projects grid gives it a fixed width per column, so rows keep a natural
/// (unequal) height without overflowing.
class ProjectCard extends StatefulWidget {
  const ProjectCard({required this.project, super.key});

  final Project project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  void _setHovering(bool hovering) {
    if (_hovering != hovering) {
      setState(() => _hovering = hovering);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Project project = widget.project;
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;
    final ColorScheme colors = theme.colorScheme;
    final String? url = project.url;

    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovering ? colors.primary : colors.outlineVariant,
            ),
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
                  style: text.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
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
        ),
      ),
    );
  }
}
