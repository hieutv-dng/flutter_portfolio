import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    // Reduced motion drops the staggered entrance; content shows immediately.
    final bool animate = !MediaQuery.disableAnimationsOf(context);

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
                  _entrance(
                    CircleAvatar(
                      radius: isMobile ? 56 : 72,
                      backgroundImage: AssetImage(profile.avatarAsset),
                    ),
                    0,
                    animate: animate,
                  ),
                  const SizedBox(height: 24),
                  _entrance(
                    Text(
                      profile.name,
                      textAlign: TextAlign.center,
                      style:
                          (isMobile ? text.headlineMedium : text.displaySmall)
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    1,
                    animate: animate,
                  ),
                  const SizedBox(height: 8),
                  _entrance(
                    Text(
                      profile.role,
                      textAlign: TextAlign.center,
                      style: text.titleMedium?.copyWith(color: Colors.white70),
                    ),
                    2,
                    animate: animate,
                  ),
                  const SizedBox(height: 12),
                  _entrance(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Text(
                        profile.tagline,
                        textAlign: TextAlign.center,
                        style: text.bodyLarge?.copyWith(color: Colors.white70),
                      ),
                    ),
                    3,
                    animate: animate,
                  ),
                  const SizedBox(height: 20),
                  _entrance(
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        for (final SocialLink link in socials)
                          SocialIconButton(link: link, color: Colors.white),
                      ],
                    ),
                    4,
                    animate: animate,
                  ),
                  const SizedBox(height: 20),
                  _entrance(
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
                    5,
                    animate: animate,
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

/// Wraps a hero element in the staggered entrance: a fade + short upward slide
/// whose start is offset by [index] (80ms per step) so elements cascade in.
/// Returns [child] untouched when [animate] is false (reduced motion). The last
/// element starts at 400ms and finishes under 900ms total.
Widget _entrance(Widget child, int index, {required bool animate}) {
  if (!animate) {
    return child;
  }
  return child
      .animate(delay: (80 * index).ms)
      .fadeIn(duration: 400.ms)
      .slideY(
        begin: 0.15,
        end: 0,
        duration: 400.ms,
        curve: Curves.easeOutCubic,
      );
}
