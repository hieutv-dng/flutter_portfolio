# Portfolio Phase 5 — Tests & QA

**Date**: 2026-07-04 16:39
**Severity**: Low
**Component**: Test suite + NavBar (`lib/src/ui/widgets/nav_bar.dart`)
**Status**: Done

## What Happened

Implemented Phase 5 test coverage (widget + data tests) for the single-page portfolio and ran the QA gate. Writing the mobile-nav test surfaced a real double-hamburger bug in the shipped NavBar, which was fixed (user-approved) before finalizing.

## The Bug the Tests Caught

On compact layouts the app rendered **two** hamburger buttons. Cause: `Scaffold` sets an `endDrawer`, and `AppBar` auto-injects its own `EndDrawerButton` (also `Icons.menu`, same "Open navigation menu" tooltip) whenever `actions` is null/empty. NavBar stuffed all controls in `title` (Row + Spacer) and left `actions` empty, so the framework button stacked on top of NavBar's own hamburger. Desktop was unaffected (`endDrawer` is null there → no injection), which is exactly why only the mobile test failed — a clean cross-check of the diagnosis.

Fix (chosen over "rely on framework button", which would have changed NavBar's public API): move controls (nav links, theme toggle, hamburger) from `title` into `AppBar.actions` and add `centerTitle: false`. A non-empty `actions` stops the auto-injection. Logo stays in `title`; NavBar's public API (`onMenuTap` et al.) and `home_page.dart` are unchanged.

## Technical Details

- Helper `test/helpers/pump_portfolio.dart`: pumps `PortfolioApp` at a fixed logical size (dpr pinned to 1 → drives breakpoints), resets viewport + the static `PortfolioApp.themeMode` notifier via `addTearDown` to prevent cross-test leakage.
- 5 test files, 13 tests / 8 groups: app smoke; render 5 sections + scroll to footer; desktop nav (inline links, no hamburger, tap → real scroll asserted via before/after `dy`); mobile nav (hamburger opens drawer via `ScaffoldState.isEndDrawerOpen`, link closes it + scrolls); projects grid card count bound to `kPortfolioData.projects.length`; `RevealOnScroll` reduced-motion shows child immediately (asserts child present **and** no `Animate` wrapper); data sanity.
- Old `test/widget_test.dart` smoke folded into `home_page_test.dart` and deleted.

## Decisions Made

- Fix NavBar via `actions` refactor (visual parity, single file, no API change) — user picked this over dropping the custom hamburger.
- L1 (nav-link hover accent likely a no-op under M3 default `TextButton` foreground) is **pre-existing and out of Phase 5 scope** → left as backlog for the project owner.
- No new deps (evaluated `mocktail`, rejected — local assets decode fine in `flutter_test`).

## Verification

- `flutter analyze` → 0 issues (under strict lint: `directives_ordering` + `always_declare_return_types`)
- `flutter test` → 13/13, green 3× incl. randomized order (not flaky)
- `dart format --set-exit-if-changed .` → clean
- `flutter build web --release` → `✓ Built build/web`
- `ck:code-reviewer` → DONE, no blockers; applied its L2 suggestion (assert `find.byType(HeroSection)` instead of relying on the nav-shared name text)

## Next Steps

1. Manual smoke on Chrome + Safari (scroll, nav, hover, splash) — agent env has no interactive browser.
2. Phase 6: CI/CD deploy.
3. Backlog: decide intent of desktop nav-link hover accent (L1).

---

**Status**: DONE
**Summary**: Phase 5 test suite implemented and green; QA caught and fixed a mobile double-hamburger regression via an `AppBar.actions` refactor with no public-API change.
**Concerns/Blockers**: None blocking. Manual 2-browser smoke pending (handoff to user); L1 hover-accent is pre-existing backlog.
