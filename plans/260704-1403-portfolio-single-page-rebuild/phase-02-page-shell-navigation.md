---
phase: 2
title: "Page Shell & Navigation"
status: done
effort: "1d"
priority: P1
dependencies: [1]
---

# Phase 2: Page Shell & Navigation

<!-- Updated: Validation Session 1 - theme toggle button (nav_bar + nav_drawer, ValueNotifier<ThemeMode>), openExternalLink guard try/catch -->

## Overview

Dựng khung trang single-page: HomePage scroll dọc chứa 5 section slot, navbar responsive (desktop: links inline; mobile: hamburger + endDrawer), scroll-to-section, và Hero section hoàn chỉnh.

## Requirements

- Functional: click nav link → cuộn mượt tới section tương ứng; Hero full-viewport với avatar, name, role, social links, 2 CTA (Download CV, Contact)
- Non-functional: hoạt động đủ 3 breakpoints; không jank khi cuộn; semantics/tooltip cho icon buttons (a11y)

## Architecture

- `home_page.dart` (StatefulWidget):
  - Danh sách section: `List<({String label, GlobalKey key, Widget child})>` — nguồn duy nhất cho cả navbar và body
  - Scroll-to: `Scrollable.ensureVisible(key.currentContext!, duration: 450ms, curve: Curves.easeInOutCubic)` — chịu được section cao thấp khác nhau, không cần tính offset tay
  - Body: `SingleChildScrollView` + `Column` các section (5 section tĩnh, không cần sliver/lazy — KISS)
- Navbar: `Scaffold.appBar` cố định. Desktop (≥1024): logo/name trái + `TextButton` links phải. Mobile/tablet: hamburger mở `endDrawer` cùng data links
- Theme toggle: `IconButton` (sun/moon) nhận `ValueNotifier<ThemeMode>` từ `app.dart`; desktop đặt cuối hàng links (appBar `actions`), mobile trong `endDrawer` (hoặc appBar actions). Bấm → cycle/flip light↔dark (lần đầu từ `system` resolve theo `MediaQuery.platformBrightness` rồi set explicit). Session-only, no persist
- Hero: `SizedBox(height: viewport - kToolbarHeight)`, nền `bg.jpeg` `DecorationImage(fit: cover)` + overlay tối gradient, avatar `CircleAvatar` từ `IMG_7344.jpg`, text theo `Theme.textTheme`, social row + CTAs
- Widgets dùng chung:
  - `section_container.dart`: maxWidth 1140, padding ngang responsive (16/32/64), padding dọc 80/64/48
  - `social_icon_button.dart`: `SvgPicture.asset` + `IconButton`, mở link qua `url_launcher` (`launchUrl`, web mở tab mới), tooltip = label
- Link mở ngoài: helper `open_external_link.dart` (1 hàm `Future<void> openExternalLink(String url)`) — nơi duy nhất gọi url_launcher, dễ test/mock. Guard: bỏ qua khi url rỗng/`#`, `try/catch` quanh `launchUrl` (log debug, nuốt lỗi) để CV placeholder `#` hay URL hỏng không crash app

## Related Code Files

- Modify: `lib/src/ui/home/home_page.dart` (thay placeholder Phase 1)
- Create: `lib/src/ui/sections/hero_section.dart`, `lib/src/ui/widgets/section_container.dart`, `lib/src/ui/widgets/social_icon_button.dart`, `lib/src/ui/widgets/nav_bar.dart`, `lib/src/ui/widgets/nav_drawer.dart`, `lib/src/utils/open_external_link.dart`
- Create (stub): 4 section stub (`about/projects/experience/contact_section.dart`) — mỗi cái `SectionContainer` + heading placeholder để nav hoạt động end-to-end ngay phase này

## Implementation Steps

1. Tạo `section_container.dart`, `social_icon_button.dart`, `open_external_link.dart`
2. Tạo `nav_bar.dart` (PreferredSizeWidget, nhận `items: List<({String label, VoidCallback onTap})>` + `themeMode: ValueNotifier<ThemeMode>` cho nút toggle) + `nav_drawer.dart` cùng contract
3. Tạo `hero_section.dart` đọc `kPortfolioData.profile` + `socialLinks`; CTA "Contact" nhận callback scroll từ HomePage; "Download CV" mở `profile.cvUrl`
4. Tạo 4 section stubs với heading
5. Ghép `home_page.dart`: sections list + GlobalKeys, appBar/endDrawer theo breakpoint, SingleChildScrollView
6. Manual check chrome (port 5010): resize 390px / 800px / 1440px — nav đổi dạng đúng, scroll-to đúng vị trí, hero không overflow
7. Gates: `flutter analyze && flutter test`

## Success Criteria

- [x] Nav links cuộn mượt tới đúng section cả desktop lẫn drawer (drawer tự đóng trước khi cuộn) — code-verified; manual chrome resize (390/800/1440) chờ user xác nhận
- [x] Hero render đủ avatar/name/role/social/CTA, không overflow ở 320px width — Wrap social/CTA + inner scroll dọc
- [x] Nút toggle theme đổi light↔dark tức thì (cả navbar desktop lẫn drawer); "Download CV" (`#`) bấm không crash (guard `#` + try/catch)
- [x] 0 analyze issues, tests pass (+ `flutter build web` compile OK, Wasm dry-run pass)

## Risk Assessment

- `ensureVisible` lệch khi ảnh chưa load xong đổi layout: hero/ section có kích thước xác định trước (SizedBox height, aspect ratio) — không phụ thuộc ảnh load
- bg.jpeg nặng làm LCP chậm: chấp nhận ở phase này; Phase 4 thêm splash; nếu >500KB cân nhắc nén lại
- Drawer + ensureVisible race: `Navigator.pop` trước, `Future.delayed` ngắn hoặc `WidgetsBinding.addPostFrameCallback` rồi mới cuộn
