import 'package:flutter_portfolio/src/data/portfolio_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('kPortfolioData', () {
    test('every content collection is non-empty', () {
      expect(kPortfolioData.socials, isNotEmpty);
      expect(kPortfolioData.skills, isNotEmpty);
      expect(kPortfolioData.projects, isNotEmpty);
      expect(kPortfolioData.experiences, isNotEmpty);
    });

    test('profile fields are populated and the avatar is a bundled asset', () {
      final Profile profile = kPortfolioData.profile;
      expect(profile.name, isNotEmpty);
      expect(profile.role, isNotEmpty);
      expect(profile.tagline, isNotEmpty);
      expect(profile.bio, isNotEmpty);
      expect(profile.email, isNotEmpty);
      // '#' is an accepted CV placeholder, but the field is never empty.
      expect(profile.cvUrl, isNotEmpty);
      expect(profile.avatarAsset, startsWith('assets/'));
    });

    test('social links reference bundled SVG icons and real URLs', () {
      for (final SocialLink link in kPortfolioData.socials) {
        expect(link.label, isNotEmpty);
        expect(link.iconAsset, startsWith('assets/'));
        expect(link.iconAsset, endsWith('.svg'));
        expect(link.url, isNotEmpty);
      }
    });

    test('skill groups are labelled and populated', () {
      for (final SkillGroup group in kPortfolioData.skills) {
        expect(group.category, isNotEmpty);
        expect(group.skills, isNotEmpty);
      }
    });

    test('projects have content and a non-empty URL when linked', () {
      for (final Project project in kPortfolioData.projects) {
        expect(project.title, isNotEmpty);
        expect(project.description, isNotEmpty);
        expect(project.tags, isNotEmpty);
        final String? url = project.url;
        if (url != null) {
          expect(url, isNotEmpty);
        }
      }
    });

    test('experiences are fully described', () {
      for (final Experience experience in kPortfolioData.experiences) {
        expect(experience.company, isNotEmpty);
        expect(experience.role, isNotEmpty);
        expect(experience.period, isNotEmpty);
        expect(experience.description, isNotEmpty);
      }
    });
  });
}
