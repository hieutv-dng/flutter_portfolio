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
| 1 | [Foundation & Assets](./phase-01-foundation-assets.md) | Pending |
| 2 | [Page Shell & Navigation](./phase-02-page-shell-navigation.md) | Pending |
| 3 | [Content Sections](./phase-03-content-sections.md) | Pending |
| 4 | [Animations & Web Polish](./phase-04-animations-web-polish.md) | Pending |
| 5 | [Tests & QA](./phase-05-tests-qa.md) | Pending |
| 6 | [CI/CD Deploy](./phase-06-ci-cd-deploy.md) | Pending |

## Acceptance Criteria

- `flutter analyze` = 0 issues với ruleset nghiêm hiện có (không nới lỏng rule nào)
- `flutter test` pass toàn bộ; `dart format` clean
- Responsive 3 breakpoints: mobile <768, tablet <1024, desktop ≥1024
- Animations chạy mượt, có guard `disableAnimations` (reduced motion)
- Push master → CI analyze + test + build + deploy → site mới live tại root domain
- Site 2021 vẫn khôi phục được từ git history repo github.io (không force_orphan)

## Dependencies

- Cross-plan: none (plan duy nhất trong repo)
- Pub deps mới: `flutter_animate`, `flutter_svg`, `url_launcher` — chọn version thoả Dart SDK `>=3.2.5 <4.0.0`
- External: repo `hieutv-dng/hieutv-dng.github.io` (deploy target + nguồn assets cũ)
- Manual one-time (user): SSH deploy key (write) trên repo github.io + secret `ACTIONS_DEPLOY_KEY` trên repo này (chi tiết Phase 6)
- Toolchain: Flutter 3.41.x stable, chỉ platform web

## Unresolved Questions

- Palette/seed color + font cuối cùng: dùng tạm seed tối giản (Phase 1), user chốt khi thay nội dung thật
- URL download CV thật: placeholder `#` tới khi user cung cấp
