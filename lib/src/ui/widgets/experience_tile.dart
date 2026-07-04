import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';

/// One entry in the experience timeline: a dot with a vertical rule running down
/// the left gutter, and the period / role @ company / description on the right.
///
/// [isLast] drops the trailing rule and bottom spacing so the timeline ends
/// cleanly on the final entry. Wrapped in an `IntrinsicHeight` by the layout so
/// the rule always spans the full height of its entry, whatever the text length
/// or scale factor.
class ExperienceTile extends StatelessWidget {
  const ExperienceTile({
    required this.experience,
    this.isLast = false,
    super.key,
  });

  final Experience experience;

  /// Whether this is the final entry — hides the connecting rule below the dot.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;
    final ColorScheme colors = theme.colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Timeline gutter: a dot marking the entry, then a rule running down
          // to the next one (centred under the dot by the column's alignment).
          Column(
            children: <Widget>[
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: colors.outlineVariant),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    experience.period,
                    style: text.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${experience.role} @ ${experience.company}',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    experience.description,
                    style: text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
