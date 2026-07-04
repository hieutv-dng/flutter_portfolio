import 'package:flutter/material.dart';

import '../../utils/breakpoints.dart';
import 'theme_toggle_button.dart';

/// A labelled navigation action: tapping [onTap] scrolls to its section.
typedef NavItem = ({String label, VoidCallback onTap});

/// Top navigation bar shared across breakpoints.
///
/// Desktop (≥1024) shows the name plus inline text links; tablet/mobile collapse
/// the links into a hamburger that opens the end drawer. The theme toggle is
/// always visible.
class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({
    required this.title,
    required this.items,
    required this.themeMode,
    required this.onLogoTap,
    this.onMenuTap,
    super.key,
  });

  /// Brand label on the left; tapping it returns to the hero.
  final String title;
  final List<NavItem> items;
  final ValueNotifier<ThemeMode> themeMode;

  /// Scrolls back to the hero; wired to the name/logo.
  final VoidCallback onLogoTap;

  /// Opens the end drawer on compact layouts. Null on desktop.
  final VoidCallback? onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ScreenSize.of(context) == ScreenSize.desktop;
    final ThemeData theme = Theme.of(context);
    final TextTheme text = theme.textTheme;
    final ColorScheme colors = theme.colorScheme;
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: onLogoTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  title,
                  style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Spacer(),
            if (isDesktop) ...<Widget>[
              for (final NavItem item in items)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextButton(
                    onPressed: item.onTap,
                    // Text shifts to the accent on hover; null keeps the
                    // default colour otherwise.
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) =>
                            states.contains(WidgetState.hovered)
                            ? colors.primary
                            : null,
                      ),
                    ),
                    child: Text(item.label),
                  ),
                ),
              const SizedBox(width: 8),
              ThemeToggleButton(themeMode: themeMode),
            ] else ...<Widget>[
              ThemeToggleButton(themeMode: themeMode),
              IconButton(
                tooltip: 'Open navigation menu',
                icon: const Icon(Icons.menu),
                onPressed: onMenuTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
