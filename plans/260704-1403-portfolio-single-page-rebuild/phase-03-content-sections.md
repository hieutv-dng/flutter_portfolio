---
phase: 3
title: "Content Sections"
status: pending
effort: "1d"
priority: P1
dependencies: [2]
---

# Phase 3: Content Sections

## Overview

Hoàn thiện 4 section nội dung từ stub: About/Skills, Projects, Experience, Contact + footer. Tất cả đọc từ `kPortfolioData`, responsive đủ 3 breakpoints.

## Requirements

- Functional:
  - About: bio + avatar phụ (hoặc chỉ text) 2 cột desktop / stack mobile; skills = chip groups theo `SkillGroup`
  - Projects: grid card — desktop 3 cột, tablet 2, mobile 1; card: title, description (max 3 dòng ellipsis), tag chips, icon link mở `project.url` nếu có
  - Experience: timeline dọc (period, role @ company, description) — rule line + dot bên trái
  - Contact: heading + nút email (`mailto:` qua `openExternalLink`) + social row + footer "© 2026 Hieu Tran · Built with Flutter"
- Non-functional: KHÔNG contact form (cần backend — ngoài scope); text scale 1.3 không vỡ layout

## Architecture

- Mỗi section = StatelessWidget đọc const data, bọc trong `SectionContainer` (đồng nhất spacing/width)
- Grid projects: `LayoutBuilder` + `Wrap` hoặc `GridView.count(shrinkWrap, NeverScrollableScrollPhysics)` — chọn `Wrap` với item width tính theo cột để tránh lồng scrollable
- Heading section thống nhất: widget nhỏ `section_heading.dart` (eyebrow + title) dùng chung 4 section
- KHÔNG thêm package mới ở phase này

## Related Code Files

- Modify: `lib/src/ui/sections/about_section.dart`, `projects_section.dart`, `experience_section.dart`, `contact_section.dart` (từ stub Phase 2)
- Create: `lib/src/ui/widgets/section_heading.dart`, `lib/src/ui/widgets/project_card.dart`, `lib/src/ui/widgets/experience_tile.dart`

## Implementation Steps

1. `section_heading.dart` — eyebrow mono nhỏ + title lớn, căn theo breakpoint
2. About/Skills: layout 2 cột desktop (`Row` + `Expanded`), stack mobile; skills render `Wrap` chips theo group
3. `project_card.dart` + Projects grid theo cột responsive; verify với 6 placeholder projects
4. `experience_tile.dart` + timeline (Column + custom left rule bằng `Container` width 2)
5. Contact + footer
6. Manual check 3 breakpoints + text scale 1.3 (chrome devtools)
7. Gates: `flutter analyze && flutter test`

## Success Criteria

- [ ] 4 section render đúng data placeholder, đủ 3 breakpoints không overflow
- [ ] Đổi thử 1 giá trị trong `portfolio_data.dart` → UI cập nhật, không sửa file UI nào
- [ ] 0 analyze issues, tests pass

## Risk Assessment

- Card description dài vỡ grid: `maxLines: 3` + `TextOverflow.ellipsis`, card height tự nhiên theo hàng
- Lồng scrollable (GridView trong SingleChildScrollView) gây assert: dùng `Wrap`/shrinkWrap + physics never — đã chốt dùng `Wrap`
- Chip nhiều tràn ngang mobile: `Wrap` mặc định xuống dòng — kiểm tra padding
