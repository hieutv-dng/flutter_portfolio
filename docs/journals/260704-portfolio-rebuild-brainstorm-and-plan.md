# Portfolio Rebuild Investigation & Planning Session

**Date**: 2026-07-04 14:03
**Severity**: Medium
**Component**: Portfolio site + deploy pipeline
**Status**: Planned (implementation pending)

## What Happened

Brainstorm + planning session to recover lost portfolio source code and rebuild `hieutv-dng.github.io` in this repo. Investigated site origin, evaluated 3 architectural approaches, drafted 6-phase implementation plan with full CI/CD pipeline.

## The Brutal Truth

Live site at https://hieutv-dng.github.io/ has been stale since **2026-06-27** (5 years). The 2021 Flutter source (project named `hieutv`) is **permanently lost** — doesn't exist in any of ~50 account repos, public or private. Repo `flutter_portfolio` (created 2024-01-19) was meant to be the source but contains only boilerplate counter, meaning the recovery job was never started.

## Technical Details

**Site archaeology:**
- Live site served from `hieutv-dng/hieutv-dng.github.io` (build output only: `main.dart.js` 1.7MB, `flutter_service_worker.js`, no source)
- Original build: single push 2021-06-27 with `version.json` app_name=hieutv
- Recoverable assets from old repo: `IMG_7344.jpg`, `bg.jpeg`, 7 SVG icons (behance/dribbble/github/linkedin/twitter/check/download)

**Approach chosen (PA1 "Lean single-page"):**
- 1 route, 5 sections (Hero/About/Skills/Projects/Experience/Contact) via `SingleChildScrollView` + scroll-to anchors
- No state-mgmt package, no go_router (YAGNI); data in `lib/src/data/portfolio_data.dart`
- Dependencies: `flutter_animate`, `flutter_svg`, `url_launcher`
- Responsive 3 breakpoints: mobile <768, tablet <1024, desktop ≥1024
- Material 3 theme with `ColorScheme.fromSeed` (per CLAUDE.md convention)

**Deploy:** GitHub Actions (`.github/workflows/deploy.yml`) push → `peaceiris/actions-gh-pages` + SSH deploy key → external repo `hieutv-dng.github.io` master branch, preserving 2021 git history (no `force_orphan`).

## Decisions Made

- English content placeholder structure (user supplies real bio/CV/projects later)
- No routing complexity; evaluated & rejected multi-route + go_router as over-engineering
- SSH deploy key setup (manual one-time: public key → repo Deploy Keys, private → secret `ACTIONS_DEPLOY_KEY`)

## Next Steps

1. Phase 1: Foundation & assets (theme, data models, boilerplate structure)
2. Phase 2–6: Page shell → sections → animations → tests → CI/CD
3. User: prepare final palette/font decision + real content (bio/projects/CV link) — doesn't block Phase 1–2

## Artifacts Created

- Brainstorm report: `plans/reports/brainstorm-260704-1403-portfolio-single-page-rebuild-report.md`
- Plan directory: `plans/260704-1403-portfolio-single-page-rebuild/` with 6 phase files + `plan.md`
- Active plan set; 6 session tasks created (chained, pending implementation)

---

**Status**: DONE
**Summary**: Established that 2021 portfolio source is lost; designed PA1 (lean single-page) rebuild in Flutter with GitHub Actions CI/CD; plan + phases drafted, ready for Phase 1 implementation.
**Concerns/Blockers**: None — all dependencies and manual setup tasks (deploy key) identified for handoff to user.
