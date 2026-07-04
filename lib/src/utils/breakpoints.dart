import 'package:flutter/widgets.dart';

/// Responsive size buckets for the portfolio layout.
///
/// Thresholds in logical pixels: `mobile` below 768, `tablet` below 1024,
/// `desktop` at 1024 and above. Sections read the current bucket to pick
/// column counts, spacing, and font sizes.
enum ScreenSize {
  mobile,
  tablet,
  desktop;

  /// Resolves the [ScreenSize] for [context] from the media query width.
  ///
  /// Uses [MediaQuery.sizeOf] so widgets rebuild only when the size changes,
  /// not on every unrelated media query update.
  static ScreenSize of(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < 768) {
      return ScreenSize.mobile;
    }
    if (width < 1024) {
      return ScreenSize.tablet;
    }
    return ScreenSize.desktop;
  }
}
