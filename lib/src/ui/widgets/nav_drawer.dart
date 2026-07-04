import 'package:flutter/material.dart';

import 'nav_bar.dart' show NavItem;
import 'theme_toggle_button.dart';

/// End drawer shown on tablet/mobile. Lists the same [NavItem]s as the bar and
/// carries the theme toggle. Each entry closes the drawer first, then scrolls on
/// the next frame so the close animation and the scroll don't fight over layout.
class NavDrawer extends StatelessWidget {
  const NavDrawer({required this.items, required this.themeMode, super.key});

  final List<NavItem> items;
  final ValueNotifier<ThemeMode> themeMode;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Menu', style: text.titleLarge),
                  ThemeToggleButton(themeMode: themeMode),
                ],
              ),
            ),
            const Divider(height: 1),
            for (final NavItem item in items)
              ListTile(
                title: Text(item.label),
                onTap: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => item.onTap(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
