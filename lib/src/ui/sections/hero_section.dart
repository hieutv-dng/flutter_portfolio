import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/portfolio_data.dart';
import '../../utils/breakpoints.dart';
import '../../utils/open_external_link.dart';
import '../widgets/social_icon_button.dart';

/// Full-viewport landing hero: background photo with a dark gradient scrim,
/// avatar, name / role / tagline, social row, and the two primary CTAs. Always
/// renders light text on the dark scrim regardless of the active theme.
class HeroSection extends StatelessWidget {
  const HeroSection({required this.onContactPressed, super.key});

  /// Scrolls to the contact section; wired to the "Contact" CTA.
  final VoidCallback onContactPressed;

  @override
  Widget build(BuildContext context) {
    final Profile profile = kPortfolioData.profile;
    final List<SocialLink> socials = kPortfolioData.socials;
    final ScreenSize size = ScreenSize.of(context);
    final TextTheme text = Theme.of(context).textTheme;
    final bool isMobile = size == ScreenSize.mobile;

    // Fill the viewport below the app bar, but never collapse below a usable
    // minimum on very short windows (content then scrolls inside the hero).
    final double height = math.max(
      480,
      MediaQuery.sizeOf(context).height - kToolbarHeight,
    );

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xB3000000), Color(0xD9000000)],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: isMobile ? 56 : 72,
                    backgroundImage: AssetImage(profile.avatarAsset),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: (isMobile ? text.headlineMedium : text.displaySmall)
                        ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.role,
                    textAlign: TextAlign.center,
                    style: text.titleMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      profile.tagline,
                      textAlign: TextAlign.center,
                      style: text.bodyLarge?.copyWith(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      for (final SocialLink link in socials)
                        SocialIconButton(link: link, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () => openExternalLink(profile.cvUrl),
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Download CV'),
                      ),
                      OutlinedButton(
                        onPressed: onContactPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        child: const Text('Contact'),
                      ),
                    ],
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
