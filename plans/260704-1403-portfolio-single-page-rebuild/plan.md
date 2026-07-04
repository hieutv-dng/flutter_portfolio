---
title: "Portfolio Single-Page Rebuild & Auto-Deploy"
description: "Rebuild hieutv-dng.github.io as multi-section single-page Flutter web portfolio, auto-deployed via GitHub Actions"
status: pending
priority: P2
branch: "master"
tags: [feature, frontend, infra]
blockedBy: []
blocks: []
created: "2026-07-04T07:14:52.068Z"
createdBy: "ck:plan"
source: skill
---

# Portfolio Single-Page Rebuild & Auto-Deploy

## Overview

Site live https://hieutv-dng.github.io/ = build Flutter 2021 đã stale, source mất. Plan này build lại: portfolio single-page multi-section (Hero, About/Skills, Projects, Experience, Contact) bằng Flutter web trong repo này, nội dung placeholder tiếng Anh + assets 2021 khôi phục từ repo cũ, deploy tự động sang repo `hieutv-dng/hieutv-dng.github.io` (giữ root domain) qua GitHub Actions + deploy key.

Design đã chốt: [Brainstorm report](../reports/brainstorm-260704-1403-portfolio-single-page-rebuild-report.md) — PA1 "Lean single-page".

## User Decisions (không tự đảo ngược)

- Multi-section đầy đủ; 1 route duy nhất, scroll navigation — KHÔNG go_router
- Deploy: GitHub Actions push sang external repo, giữ root domain
- Content: placeholder EN có cấu trúc + assets 2021; thay nội dung thật = chỉ sửa `lib/src/data/portfolio_data.dart`
- KHÔNG state-mgmt package, KHÔNG l10n, KHÔNG backend/CMS

## Phases

| Phase | Name | Status |
|-------|------|--------|
| 1 | [Foundation & Assets](./phase-01-foundation-assets.md) | Done |
| 2 | [Page Shell & Navigation](./phase-02-page-shell-navigation.md) | Done |
| 3 | [Content Sections](./phase-03-content-sections.md) | Pending |
| 4 | [Animations & Web Polish](./phase-04-animations-web-polish.md) | Pending |
| 5 | [Tests & QA](./phase-05-tests-qa.md) | Pending |
| 6 | [CI/CD Deploy](./phase-06-ci-cd-deploy.md) | Pending |

## Acceptance Criteria

- `flutter analyze` = 0 issues với `flutter_lints` + 2 rule bổ sung `directives_ordering`, `always_declare_return_types` (bật ở Phase 1) — không nới lỏng rule nào
- `flutter test` pass toàn bộ; `dart format` clean
- Responsive 3 breakpoints: mobile <768, tablet <1024, desktop ≥1024
- Animations chạy mượt, có guard `disableAnimations` (reduced motion)
- Push master → CI analyze + test + build + deploy → site mới live tại root domain
- Site 2021 vẫn khôi phục được từ git history repo github.io (không force_orphan)

## Dependencies

- Cross-plan: none (plan duy nhất trong repo)
- Pub deps mới: `flutter_animate`, `flutter_svg`, `url_launcher` — chọn version thoả Dart SDK `>=3.11.5 <4.0.0` (pubspec `^3.11.5`, verify `flutter pub add`)
- External: repo `hieutv-dng/hieutv-dng.github.io` (deploy target + nguồn assets cũ)
- Manual one-time (user): SSH deploy key (write) trên repo github.io + secret `ACTIONS_DEPLOY_KEY` trên repo này (chi tiết Phase 6)
- Toolchain: Flutter 3.41.x stable, chỉ platform web

## Unresolved Questions

- Palette/seed color + font cuối cùng: dùng tạm seed tối giản (Phase 1), user chốt khi thay nội dung thật
- URL download CV thật: giữ placeholder `#` (Q2) — nút vẫn render; `openExternalLink` guard try/catch để `launchUrl('#')` không crash

## Validation Log

### Session 1 — 2026-07-04
**Trigger:** `/ck:plan validate` — pre-implementation critical-questions interview + Full-tier verification (6 phases)
**Questions asked:** 4

#### Verification Results
- Tier: Full (6 phases) | Claims checked: 12 | Verified: 10 | Failed: 2 | Unverified: 0
- VERIFIED: repo `hieutv-dng/hieutv-dng.github.io`@master tồn tại; `assets/assets/images/{IMG_7344.jpg,bg.jpeg}`; `assets/assets/icons/{behance,check,download,dribble,github,linkedin,twitter}.svg`; root `favicon.png` + `icons/{Icon-192,Icon-512}.png`; `flutter_service_worker.js` cũ 2021 (Phase 6 risk hợp lệ); `web/index.html` dùng `flutter_bootstrap.js` (Phase 4); `.gitignore` ignore `/build/`; Flutter local 3.41.9 / Dart 3.11.5
- FAILED-1 [Fact Checker]: plan + phase-01 ghi Dart SDK `>=3.2.5` — pubspec thực tế `^3.11.5`. Đã sửa (factual, không cần interview).
- FAILED-2 [Fact Checker]: phase-01 liệt kê `directives_ordering`/`always_declare_return_types` như đang enforce — `flutter_lints` không bật (CLAUDE.md xác nhận). → Q1.

#### Questions & Answers
1. **[Architecture]** Ruleset lint (2 rule không có trong flutter_lints)?
   - Options: Giữ flutter_lints chuẩn | **Thêm strict rules**
   - **Answer:** Thêm strict rules — bật 2 rule trong `analysis_options.yaml`; mọi file phải tuân import ordering + explicit return types.
2. **[Risk]** Nút "Download CV" khi cvUrl = `#`?
   - Options: Ẩn khi rỗng | Hiện disable | **Giữ link `#`**
   - **Answer:** Giữ `#` — nút render; `openExternalLink` guard try/catch để không crash.
3. **[Architecture]** Theme mode default + toggle?
   - Options: Dark-only | Theo hệ thống | Có toggle
   - **Answer (Other):** Mặc định `ThemeMode.system` **+** nút toggle — giữ cả light+dark ThemeData; `ValueNotifier<ThemeMode>` (no state pkg); nút ở navbar/drawer; session-only (no persist).
4. **[Risk]** pubspec.lock bị gitignore?
   - Options: **Commit pubspec.lock** | Giữ ignore
   - **Answer:** Commit — bỏ khỏi `.gitignore`, CI build tái lập.

#### Confirmed Decisions
- Lint: +`directives_ordering` +`always_declare_return_types` (Phase 1)
- CV: giữ `#`, guard `launchUrl` (Phase 2)
- Theme: `ValueNotifier<ThemeMode>` default `system` + toggle navbar (Phase 1/2), no persist (persist = defer, cần `shared_preferences`)
- CI: commit `pubspec.lock` (Phase 1), pin Flutter `3.41.9` (Phase 6)
- Fact fixes: Dart SDK `3.11.5`; toàn bộ assets verified

#### Impact on Phases
- Phase 1: `analysis_options.yaml` (2 rule), `app.dart` themeMode notifier, `.gitignore` un-ignore lock, Dart 3.11.5
- Phase 2: theme toggle `nav_bar`/`nav_drawer`, `openExternalLink` guard
- Phase 4: theme toggle icon transition (optional)
- Phase 5: +test theme toggle (optional); tests chạy dưới strict lint
- Phase 6: pin `3.41.9`; CI hưởng lockfile reproducible

### Whole-Plan Consistency Sweep
- Files reread: `plan.md`, `phase-01`…`phase-06`
- Decision deltas checked: 6 (Dart 3.11.5, strict lint ×2, theme system+toggle, pubspec.lock commit, CV `#`+guard, Flutter pin 3.41.9)
- Reconciled stale references: 3 (acceptance-criteria lint text; Dart SDK `3.2.5`→`3.11.5`; "dark mặc định"→`system`)
- Unresolved contradictions: 0 (`3.2.5` còn lại 1 chỗ = history record trong log này, có chủ ý; Phase 3 không marker = không bị ảnh hưởng, đúng)
