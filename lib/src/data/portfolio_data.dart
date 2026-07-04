/// Immutable content models for the single-page portfolio.
///
/// Everything the UI renders is read from [kPortfolioData] — the single source
/// of truth. Swapping in real content later means editing only this file. All
/// models are `const`-constructible so the whole tree is a compile-time
/// constant (no JSON, no runtime parsing).
library;

/// Personal identity shown in the hero and about sections.
class Profile {
  const Profile({
    required this.name,
    required this.role,
    required this.tagline,
    required this.bio,
    required this.avatarAsset,
    required this.cvUrl,
  });

  final String name;
  final String role;
  final String tagline;
  final String bio;

  /// Asset path to the avatar image bundled under `assets/images/`.
  final String avatarAsset;

  /// External URL for the downloadable CV. `#` is a valid placeholder; the
  /// launcher guards it so tapping never crashes.
  final String cvUrl;
}

/// A social profile rendered as an SVG icon linking out to [url].
class SocialLink {
  const SocialLink({
    required this.label,
    required this.iconAsset,
    required this.url,
  });

  final String label;

  /// Asset path to the SVG icon bundled under `assets/icons/`.
  final String iconAsset;
  final String url;
}

/// A portfolio project card.
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.tags,
    this.url,
  });

  final String title;
  final String description;
  final List<String> tags;

  /// Optional link to the repository or live demo.
  final String? url;
}

/// A titled group of related skills.
class SkillGroup {
  const SkillGroup({required this.category, required this.skills});

  final String category;
  final List<String> skills;
}

/// A single work-history entry.
class Experience {
  const Experience({
    required this.company,
    required this.role,
    required this.period,
    required this.description,
  });

  final String company;
  final String role;
  final String period;
  final String description;
}

/// Aggregate of every content model the page needs.
class PortfolioData {
  const PortfolioData({
    required this.profile,
    required this.socials,
    required this.skills,
    required this.projects,
    required this.experiences,
  });

  final Profile profile;
  final List<SocialLink> socials;
  final List<SkillGroup> skills;
  final List<Project> projects;
  final List<Experience> experiences;
}

/// Placeholder content for all five sections. Replace the values here with the
/// real bio, links, and projects — the structure stays the same.
const PortfolioData kPortfolioData = PortfolioData(
  profile: Profile(
    name: 'Hieu Tran',
    role: 'Mobile & Flutter Engineer',
    tagline: 'I build responsive, animated cross-platform experiences.',
    bio:
        'Flutter engineer focused on polished mobile and web interfaces. '
        'I enjoy turning product ideas into fast, accessible apps that feel '
        'great to use on every screen size.',
    avatarAsset: 'assets/images/IMG_7344.jpg',
    cvUrl: '#',
  ),
  socials: <SocialLink>[
    SocialLink(
      label: 'GitHub',
      iconAsset: 'assets/icons/github.svg',
      url: 'https://github.com/hieutv-dng',
    ),
    SocialLink(
      label: 'LinkedIn',
      iconAsset: 'assets/icons/linkedin.svg',
      url: 'https://www.linkedin.com/',
    ),
    SocialLink(
      label: 'Twitter',
      iconAsset: 'assets/icons/twitter.svg',
      url: 'https://twitter.com/',
    ),
    SocialLink(
      label: 'Behance',
      iconAsset: 'assets/icons/behance.svg',
      url: 'https://www.behance.net/',
    ),
    SocialLink(
      label: 'Dribbble',
      iconAsset: 'assets/icons/dribble.svg',
      url: 'https://dribbble.com/',
    ),
  ],
  skills: <SkillGroup>[
    SkillGroup(
      category: 'Languages',
      skills: <String>['Dart', 'Kotlin', 'Swift', 'TypeScript'],
    ),
    SkillGroup(
      category: 'Frameworks',
      skills: <String>['Flutter', 'Jetpack Compose', 'SwiftUI'],
    ),
    SkillGroup(
      category: 'Tooling',
      skills: <String>['Git', 'CI/CD', 'Firebase', 'REST & GraphQL'],
    ),
    SkillGroup(
      category: 'Practices',
      skills: <String>[
        'Responsive UI',
        'Animation',
        'Testing',
        'Accessibility',
      ],
    ),
  ],
  projects: <Project>[
    Project(
      title: 'cm_pedometer',
      description:
          'Step-counting plugin exposing native pedometer sensors to '
          'Flutter through a stream-based Dart API.',
      tags: <String>['Flutter', 'Plugin', 'Health'],
      url: 'https://github.com/hieutv-dng/cm_pedometer',
    ),
    Project(
      title: 'flutter_lyric',
      description:
          'Synced lyric widget with karaoke-style highlighting and '
          'smooth line-by-line scrolling.',
      tags: <String>['Flutter', 'Widget', 'Audio'],
      url: 'https://github.com/hieutv-dng/flutter_lyric',
    ),
    Project(
      title: 'ai-edge-gallery-flutter',
      description:
          'On-device generative AI gallery running Google AI Edge '
          'models fully offline on mobile.',
      tags: <String>['Flutter', 'On-device AI', 'Gallery'],
      url: 'https://github.com/hieutv-dng/ai-edge-gallery-flutter',
    ),
    Project(
      title: 'flutter_portfolio',
      description:
          'This responsive, animated single-page portfolio built '
          'entirely with Flutter for the web.',
      tags: <String>['Flutter Web', 'Responsive', 'Animation'],
      url: 'https://github.com/hieutv-dng/flutter_portfolio',
    ),
    Project(
      title: 'motion_toast',
      description:
          'Lightweight, customizable animated toast notifications for '
          'Flutter apps.',
      tags: <String>['Flutter', 'Package', 'Animation'],
    ),
    Project(
      title: 'design_system_kit',
      description:
          'Reusable Material 3 component library and design tokens '
          'shared across products.',
      tags: <String>['Flutter', 'Design System', 'Material 3'],
    ),
  ],
  experiences: <Experience>[
    Experience(
      company: 'Freelance',
      role: 'Flutter Engineer',
      period: '2023 — Present',
      description:
          'Design and ship cross-platform apps for startups, from '
          'prototypes to store releases.',
    ),
    Experience(
      company: 'Mobile Studio',
      role: 'Senior Mobile Developer',
      period: '2020 — 2023',
      description:
          'Led Flutter migrations and built shared UI libraries used '
          'across multiple client apps.',
    ),
    Experience(
      company: 'Software House',
      role: 'Mobile Developer',
      period: '2018 — 2020',
      description:
          'Delivered native Android features and adopted Flutter for '
          'new product lines.',
    ),
  ],
);
