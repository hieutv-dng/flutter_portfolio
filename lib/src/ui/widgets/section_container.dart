import 'package:flutter/material.dart';

import '../../utils/breakpoints.dart';

/// Centers section content, caps it at a comfortable reading width, and applies
/// responsive padding so every section shares the same rhythm.
///
/// Horizontal padding grows with the viewport (16 / 32 / 64) while vertical
/// padding shrinks on smaller screens (48 / 64 / 80) — dense on mobile, airy on
/// desktop.
class SectionContainer extends StatelessWidget {
  const SectionContainer({required this.child, this.background, super.key});

  /// Section body laid out inside the centered, width-capped column.
  final Widget child;

  /// Optional full-bleed color painted behind the padded content.
  final Color? background;

  /// Largest content width before extra space becomes side margin.
  static const double maxContentWidth = 1140;

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = ScreenSize.of(context);
    final double horizontal = switch (size) {
      ScreenSize.mobile => 16,
      ScreenSize.tablet => 32,
      ScreenSize.desktop => 64,
    };
    final double vertical = switch (size) {
      ScreenSize.mobile => 48,
      ScreenSize.tablet => 64,
      ScreenSize.desktop => 80,
    };
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: child,
        ),
      ),
    );
  }
}
