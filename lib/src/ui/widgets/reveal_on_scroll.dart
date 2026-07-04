import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Reveals [child] with a one-shot fade + upward slide the first time it
/// scrolls into view, then leaves it untouched.
///
/// It piggybacks on the page's shared [controller] instead of a per-widget
/// observer, and detaches its listener the moment it fires — so there is no
/// ongoing per-frame cost once revealed. The platform "reduce motion" setting
/// short-circuits the whole effect: [child] renders immediately, fully visible.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    required this.controller,
    required this.child,
    super.key,
  });

  /// The scroll view's controller, listened to for reveal detection.
  final ScrollController controller;

  /// Content revealed once it enters the viewport.
  final Widget child;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  /// Fraction of the viewport height the child's top must reach before it
  /// counts as "in view": revealed once its top passes 80% down the screen.
  static const double _revealAt = 0.8;

  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_maybeReveal);
    // Check once after first layout so a section already sitting in the
    // opening viewport reveals even if the user never scrolls it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeReveal());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_maybeReveal);
    super.dispose();
  }

  void _maybeReveal() {
    if (_revealed || !mounted) {
      return;
    }
    // Reduced motion: show the content outright and stop listening. Marking it
    // revealed keeps it visible even if the setting is switched off later in the
    // session — otherwise the animated branch would start hidden with no
    // listener left to reveal it.
    if (MediaQuery.disableAnimationsOf(context)) {
      widget.controller.removeListener(_maybeReveal);
      if (!_revealed) {
        setState(() => _revealed = true);
      }
      return;
    }
    final RenderObject? object = context.findRenderObject();
    if (object is! RenderBox || !object.hasSize) {
      return;
    }
    final double top = object.localToGlobal(Offset.zero).dy;
    final double viewport = MediaQuery.sizeOf(context).height;
    if (top <= viewport * _revealAt) {
      widget.controller.removeListener(_maybeReveal);
      setState(() => _revealed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }
    return widget.child
        .animate(target: _revealed ? 1.0 : 0.0)
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
