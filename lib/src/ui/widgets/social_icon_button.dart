import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/portfolio_data.dart';
import '../../utils/open_external_link.dart';

/// Round icon button that renders a [SocialLink]'s SVG and opens its URL in a
/// new tab. [SocialLink.label] doubles as the tooltip and semantic label so the
/// control is reachable by screen readers. On pointer devices, hovering tints
/// the icon with the theme accent.
class SocialIconButton extends StatefulWidget {
  const SocialIconButton({
    required this.link,
    this.size = 22,
    this.color,
    super.key,
  });

  final SocialLink link;

  /// Rendered SVG edge length in logical pixels.
  final double size;

  /// Resting tint for the (monochrome) SVG. Falls back to the theme's
  /// `onSurfaceVariant` so it adapts to light/dark surfaces; the hero passes
  /// white because it always sits on a dark image.
  final Color? color;

  @override
  State<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<SocialIconButton> {
  bool _hovering = false;

  void _setHovering(bool hovering) {
    if (_hovering != hovering) {
      setState(() => _hovering = hovering);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color base = widget.color ?? colors.onSurfaceVariant;
    final Color tint = _hovering ? colors.primary : base;
    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: IconButton(
        tooltip: widget.link.label,
        onPressed: () => openExternalLink(widget.link.url),
        icon: TweenAnimationBuilder<Color?>(
          duration: const Duration(milliseconds: 150),
          tween: ColorTween(end: tint),
          builder: (BuildContext context, Color? animated, Widget? child) {
            return SvgPicture.asset(
              widget.link.iconAsset,
              width: widget.size,
              height: widget.size,
              colorFilter: ColorFilter.mode(animated ?? tint, BlendMode.srcIn),
              semanticsLabel: widget.link.label,
            );
          },
        ),
      ),
    );
  }
}
