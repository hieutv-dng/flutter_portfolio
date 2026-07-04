import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/portfolio_data.dart';
import '../../utils/breakpoints.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/nav_drawer.dart';

/// One scrollable section paired with the key used to scroll to it.
typedef _Section = ({String label, GlobalKey key, Widget child});

/// The single-page shell: a vertical scroll of the five sections with a
/// responsive nav bar (inline links on desktop, an end drawer on smaller
/// screens). The section list is the single source of truth for both the body
/// and the navigation.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  /// Smoothly scrolls the section carrying [key] into view. Robust to sections
  /// of differing heights — no manual offset maths.
  void _scrollTo(GlobalKey key) {
    final BuildContext? target = key.currentContext;
    if (target == null) {
      return;
    }
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_Section> sections = <_Section>[
      (
        label: 'Home',
        key: _heroKey,
        child: HeroSection(onContactPressed: () => _scrollTo(_contactKey)),
      ),
      (label: 'About', key: _aboutKey, child: const AboutSection()),
      (label: 'Projects', key: _projectsKey, child: const ProjectsSection()),
      (
        label: 'Experience',
        key: _experienceKey,
        child: const ExperienceSection(),
      ),
      (label: 'Contact', key: _contactKey, child: const ContactSection()),
    ];

    // The nav lists every section except the hero — the name/logo returns there.
    final List<NavItem> navItems = <NavItem>[
      for (final _Section section in sections.skip(1))
        (label: section.label, onTap: () => _scrollTo(section.key)),
    ];

    final bool isDesktop = ScreenSize.of(context) == ScreenSize.desktop;

    return Scaffold(
      key: _scaffoldKey,
      appBar: NavBar(
        title: kPortfolioData.profile.name,
        items: navItems,
        themeMode: PortfolioApp.themeMode,
        onLogoTap: () => _scrollTo(_heroKey),
        onMenuTap: isDesktop
            ? null
            : () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      endDrawer: isDesktop
          ? null
          : NavDrawer(items: navItems, themeMode: PortfolioApp.themeMode),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final _Section section in sections)
              KeyedSubtree(key: section.key, child: section.child),
          ],
        ),
      ),
    );
  }
}
