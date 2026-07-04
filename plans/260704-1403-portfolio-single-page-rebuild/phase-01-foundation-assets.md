---
phase: 1
title: "Foundation & Assets"
status: pending
effort: "0.5d"
priority: P1
dependencies: []
---

# Phase 1: Foundation & Assets

## Overview

Dựng khung project: cấu trúc `lib/src/`, theme Material 3, breakpoints, data models + placeholder content, khôi phục assets 2021, thay `main.dart` counter và fix `widget_test.dart`. Kết thúc phase: app chạy được trên chrome, analyze/test xanh.

## Context Links

- Brainstorm: `../reports/brainstorm-260704-1403-portfolio-single-page-rebuild-report.md`
- Assets nguồn: repo `hieutv-dng/hieutv-dng.github.io` branch `master`, path `assets/assets/`

## Requirements

- Functional: app khởi động với HomePage placeholder; data placeholder đầy đủ 5 section; assets bundle đúng
- Non-functional: 0 analyze issues (const, directives_ordering, always_declare_return_types...); file names snake_case (lint `file_names`)

## Architecture

```
lib/
  main.dart                      # runApp(const PortfolioApp())
  src/
    app.dart                     # MaterialApp, title 'Hieu Tran', ColorScheme.fromSeed, useMaterial3
    theme/app_theme.dart         # light/dark ThemeData; seed color const dễ đổi 1 chỗ
    utils/breakpoints.dart       # ScreenSize enum (mobile/tablet/desktop) + ScreenSize.of(context); mobile <768, tablet <1024
    data/portfolio_data.dart     # models + kPortfolioData const (single source of truth)
    ui/home/home_page.dart       # placeholder Scaffold (Phase 2 thay)
```

Models (const-constructible, không JSON — data tĩnh compile-time):
- `Profile`: name, role, tagline, bio, avatarAsset, cvUrl
- `SocialLink`: label, iconAsset, url
- `Project`: title, description, tags (List<String>), url?
- `SkillGroup`: category, skills (List<String>)
- `Experience`: company, role, period, description
- `PortfolioData`: gom tất cả + `kPortfolioData` instance placeholder

## Related Code Files

- Modify: `lib/main.dart` (thay counter), `pubspec.yaml` (deps + assets + description), `test/widget_test.dart` (smoke test mới)
- Create: `lib/src/app.dart`, `lib/src/theme/app_theme.dart`, `lib/src/utils/breakpoints.dart`, `lib/src/data/portfolio_data.dart`, `lib/src/ui/home/home_page.dart`
- Create (assets): `assets/images/`, `assets/icons/`

## Implementation Steps

1. Khôi phục assets từ repo cũ (raw.githubusercontent.com, branch master):
   - `assets/assets/images/IMG_7344.jpg`, `assets/assets/images/bg.jpeg` → `assets/images/`
   - 7 svg `assets/assets/icons/{behance,check,download,dribble,github,linkedin,twitter}.svg` → `assets/icons/`
   - `favicon.png` + `icons/Icon-192.png`, `icons/Icon-512.png` (nếu có) → `web/` (đè default Flutter)
2. `pubspec.yaml`: add `flutter_animate`, `flutter_svg`, `url_launcher` (version mới nhất thoả SDK constraint — verify bằng `flutter pub add`); khai báo `assets: [assets/images/, assets/icons/]`; sửa `description`
3. Tạo `breakpoints.dart`: enum `ScreenSize {mobile, tablet, desktop}` + static `of(BuildContext)` đọc MediaQuery width
4. Tạo `app_theme.dart`: `ColorScheme.fromSeed` (seed const tạm, comment chỗ đổi), dark theme mặc định, textTheme mặc định (Roboto bundled — chưa custom font)
5. Tạo `portfolio_data.dart`: models trên + placeholder content EN (bio ~2 câu, 4 skill groups, 6 projects — dùng tên repo public thật làm placeholder: cm_pedometer, flutter_lyric, ai-edge-gallery-flutter..., 3 experience entries, social links dùng icon svg khôi phục)
6. Tạo `app.dart` + `home_page.dart` placeholder (Scaffold + Center Text) + thay `main.dart`
7. Thay `test/widget_test.dart`: pump `PortfolioApp`, expect MaterialApp render không exception
8. Gates: `flutter pub get && flutter analyze && flutter test && flutter run -d chrome` (smoke)

## Success Criteria

- [ ] Assets 2021 nằm trong `assets/`, khai báo đúng pubspec, hiển thị được
- [ ] `flutter analyze` 0 issues; `flutter test` pass
- [ ] App chạy trên chrome hiển thị HomePage placeholder
- [ ] Data placeholder đủ cho cả 5 section, sửa 1 file duy nhất

## Risk Assessment

- Version deps không thoả Dart 3.2.5: dùng `flutter pub add` để resolver tự chọn; nếu conflict, hạ major version — KHÔNG nâng SDK constraint
- Assets repo cũ thiếu file: fallback giữ icon/favicon default Flutter, ghi chú lại
- Lint nghiêm reject code: chạy analyze sau từng bước, sửa ngay
