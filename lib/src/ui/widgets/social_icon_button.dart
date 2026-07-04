import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/portfolio_data.dart';
import '../../utils/open_external_link.dart';

/// Round icon button that renders a [SocialLink]'s SVG and opens its URL in a
/// new tab. [SocialLink.label] doubles as the tooltip and semantic label so the
/// control is reachable by screen readers.
class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    required this.link,
    this.size = 22,
    this.color,
    super.key,
  });

  final SocialLink link;

  /// Rendered SVG edge length in logical pixels.
  final double size;

  /// Tint applied to the (monochrome) SVG. Falls back to the theme's
  /// `onSurfaceVariant` so it adapts to light/dark surfaces; the hero passes
  /// white because it always sits on a dark image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color resolved =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return IconButton(
      tooltip: link.label,
      onPressed: () => openExternalLink(link.url),
      icon: SvgPicture.asset(
        link.iconAsset,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(resolved, BlendMode.srcIn),
        semanticsLabel: link.label,
      ),
    );
  }
}
