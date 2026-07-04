import 'package:flutter/material.dart';

/// Shared heading for every content section: a small tinted "eyebrow" label
/// above a large title.
///
/// Kept left-aligned so it lines up with the start-aligned column that
/// `SectionContainer` centers, giving all four sections the same rhythm. The
/// eyebrow is upper-cased with wide tracking to read as a label (a bundled-font
/// substitute for a true monospace treatment — no extra font dependency).
class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.eyebrow, required this.title, super.key});

  /// Short descriptor rendered above the title.
  final String eyebrow;

  /// Section name rendered as the prominent headline.
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow.toUpperCase(),
          style: text.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: text.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
