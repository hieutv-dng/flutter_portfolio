---
phase: 5
title: "Tests & QA"
status: done
effort: "0.5d"
priority: P2
dependencies: [4]
---

# Phase 5: Tests & QA

<!-- Updated: Validation Session 1 - +test theme toggle (optional); tests chạy dưới strict lint (directives_ordering + always_declare_return_types) -->

## Overview

Phủ widget tests cho hành vi chính (render sections, navigation scroll, responsive switch) + QA checklist toàn cục trước khi nối CI. Không đuổi theo coverage % — test hành vi user-facing.

## Requirements

- Functional tests:
  1. App smoke: `PortfolioApp` pump không exception (đã có từ Phase 1 — giữ)
  2. HomePage render đủ 5 section heading (scroll tới cuối bằng `tester.scrollUntilVisible` với footer text)
  3. Nav desktop: surface 1440x900 → links inline hiển thị, không có hamburger; tap "Projects" → heading Projects visible
  4. Nav mobile: surface 390x844 → hamburger mở drawer, tap link → drawer đóng + section visible
  5. Projects grid: đúng số card = số project trong `kPortfolioData`
  6. `RevealOnScroll`: pump với `disableAnimations: true` (MediaQuery override) → child hiện ngay
  7. Data sanity: `kPortfolioData` — lists non-empty, asset paths bắt đầu `assets/`, url không rỗng khi khai báo
  8. Theme toggle (optional): pump 1440x900, tap `IconButton` toggle → `MaterialApp.themeMode` đổi khỏi `system` (light↔dark)
- Non-functional: KHÔNG tap link mở external trong test (url_launcher plugin không có trong test env — chỉ assert presence); test file cũng phải xanh dưới strict lint (`always_declare_return_types` cho `void main()`/helper)

## Architecture

- `test/helpers/pump_portfolio.dart`: hàm `pumpPortfolio(tester, {Size size})` — set `tester.view.physicalSize` + `devicePixelRatio=1`, addTearDown reset, pump `PortfolioApp`
- Test files theo màn: `test/home_page_test.dart`, `test/sections_test.dart`, `test/reveal_on_scroll_test.dart`, `test/portfolio_data_test.dart` (thay thế dần `widget_test.dart` nếu trùng — giữ 1 smoke)
- Ảnh asset trong widget test: ảnh jpg decode được trong test env; nếu HTTP/asset lỗi → dùng `mocktail`?? KHÔNG thêm dep — assets bundle local decode bình thường qua `flutter_test`

## Related Code Files

- Create: `test/helpers/pump_portfolio.dart`, `test/home_page_test.dart`, `test/sections_test.dart`, `test/reveal_on_scroll_test.dart`, `test/portfolio_data_test.dart`
- Modify: `test/widget_test.dart` (thu gọn còn app smoke hoặc gộp vào home_page_test rồi xoá)

## Implementation Steps

1. Viết helper pump + reset viewport
2. Tests 2→7 theo thứ tự requirements
3. QA checklist chạy tay:
   - `flutter analyze` → 0 issues
   - `dart format --set-exit-if-changed .` → clean
   - `flutter test` → all pass
   - `flutter build web --release` → success
   - Smoke Chrome + Safari (mở build local): scroll, nav, hover, splash
4. Fix mọi regression phát hiện — không skip/weaken test

## Success Criteria

- [x] Test pass ổn định — 13 test / 8 nhóm (7 bắt buộc + theme toggle), xanh 3 lần liên tiếp kể cả randomized-order, không flaky
- [x] QA 4 lệnh tự động xanh: `flutter analyze` 0 issues · `dart format --set-exit-if-changed .` clean · `flutter test` 13/13 · `flutter build web --release` success. Smoke Chrome+Safari: THỦ CÔNG, bàn giao user (môi trường agent không có browser tương tác)
- [x] Không còn test counter cũ (`widget_test.dart` gộp smoke vào `home_page_test.dart` rồi xoá)

## Completion Notes

- QA phát hiện + fix regression **double-hamburger** trên mobile: `Scaffold` có `endDrawer` + `AppBar` không set `actions` → framework tự chèn `EndDrawerButton` cộng hamburger tự viết = 2 icon. Fix (user duyệt): chuyển controls sang `AppBar.actions` + `centerTitle: false` trong `lib/src/ui/widgets/nav_bar.dart`; giữ nguyên public API NavBar → `home_page.dart` không đổi. Test mobile là regression guard.
- Backlog (ngoài scope, chờ chủ dự án quyết): hover-accent nav link desktop nhiều khả năng no-op vì M3 default `TextButton` foreground đã là `colorScheme.primary` (`nav_bar.dart` hover style + `app_theme.dart` không set `textButtonTheme`).
- Test files thực: `test/helpers/pump_portfolio.dart`, `test/home_page_test.dart`, `test/sections_test.dart`, `test/reveal_on_scroll_test.dart`, `test/portfolio_data_test.dart`.

## Risk Assessment

- `scrollUntilVisible` flaky với animation reveal: trong test, MediaQuery `disableAnimations: true` qua helper để reveal tức thì
- Ảnh lớn làm test chậm: chấp nhận (test env decode 2 ảnh); nếu >5s cân nhắc `precacheImage` bỏ qua
- Viewport không reset gây lây test sau: `addTearDown(tester.view.reset*)` trong helper — bắt buộc
