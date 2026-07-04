---
phase: 4
title: "Animations & Web Polish"
status: pending
effort: "0.5d"
priority: P2
dependencies: [3]
---

# Phase 4: Animations & Web Polish

<!-- Updated: Validation Session 1 - theme toggle icon transition (optional, AnimatedSwitcher) -->

## Overview

Thêm lớp "animated" cho portfolio: entrance animation hero, scroll-reveal cho section, hover effects desktop; polish `web/index.html` (loading splash, meta/SEO tags) và `manifest.json`.

## Requirements

- Functional:
  - Hero: stagger fade+slide (avatar → name → role → social → CTA) khi load, dùng `flutter_animate`
  - Section reveal: fade + slide-up chạy 1 lần khi section vào ~80% viewport
  - Hover desktop: project card scale nhẹ (1.02) + border accent; nav link đổi màu; social icon đổi màu
  - Theme toggle (Phase 2): icon sun/moon đổi mượt bằng `AnimatedSwitcher` (optional — tôn trọng `disableAnimations`)
  - Loading splash: HTML/CSS thuần trong `index.html` (tên + spinner), remove khi nhận event `flutter-first-frame`
- Non-functional:
  - Reduced motion: `MediaQuery.disableAnimations == true` → bỏ qua reveal/entrance (hiện thẳng nội dung)
  - Meta tags: title "Hieu Tran", description, `og:title/description/image`, theme-color
  - KHÔNG thêm package ngoài `flutter_animate` (đã add Phase 1); KHÔNG dùng visibility_detector

## Architecture

- `reveal_on_scroll.dart` (widget tự viết ~40-60 dòng):
  - Nhận `ScrollController` (từ HomePage) + child
  - Listener: tính vị trí render box (`localToGlobal`) so viewport height; qua ngưỡng 0.8 → set `_revealed = true` 1 lần, remove listener
  - Render: `child.animate(target: _revealed ? 1 : 0).fade().slideY(begin: 0.08)`; nếu `disableAnimations` → trả child trực tiếp
- HomePage truyền ScrollController xuống các section wrapper (bọc tại chỗ ghép Column, không sửa section nội bộ)
- Hover: `MouseRegion` + `AnimatedContainer/AnimatedScale` trong `project_card.dart`, `social_icon_button.dart`, nav links

## Related Code Files

- Create: `lib/src/ui/widgets/reveal_on_scroll.dart`
- Modify: `lib/src/ui/home/home_page.dart` (bọc reveal), `lib/src/ui/sections/hero_section.dart` (entrance), `lib/src/ui/widgets/project_card.dart` + `social_icon_button.dart` + `nav_bar.dart` (hover), `web/index.html` (splash + meta), `web/manifest.json` (name/colors)

## Implementation Steps

1. Hero entrance với `flutter_animate` interval stagger 80ms, tổng <900ms
2. Viết `reveal_on_scroll.dart` + guard `disableAnimations`; bọc 4 section trong HomePage
3. Hover effects 3 widget
4. `index.html`: splash div + inline CSS + listener `flutter-first-frame` để remove; meta description/og tags; title
5. `manifest.json`: name "Hieu Tran — Portfolio", background/theme color khớp theme
6. Manual: `flutter build web --release` + `python3 -m http.server` từ `build/web` — check splash hiện rồi biến mất, animations chạy, bật "Emulate CSS prefers-reduced-motion"/Flutter disableAnimations kiểm tra guard
7. Gates: `flutter analyze && flutter test`

## Success Criteria

- [ ] Hero entrance + section reveal chạy đúng, chỉ 1 lần mỗi section
- [ ] `disableAnimations` → nội dung hiện thẳng, không animation
- [ ] Splash hiển thị trước first frame rồi remove sạch (không đè UI)
- [ ] Meta tags đủ: title, description, og:*; 0 analyze issues, tests pass

## Risk Assessment

- Listener scroll tính toán mỗi frame gây jank: chỉ đo khi scroll event, remove listener ngay sau reveal; đo bằng `context.findRenderObject()` null-safe
- `flutter-first-frame` event đổi tên giữa versions: verify template `web/index.html` hiện tại của Flutter 3.41 (bootstrap `flutter_bootstrap.js`) — dùng đúng hook version này; fallback: remove splash trong `main()` qua `js_interop`? KHÔNG — giữ event DOM chuẩn, test thực tế bước 6
- og:image cần URL tuyệt đối: dùng `https://hieutv-dng.github.io/icons/Icon-512.png`
