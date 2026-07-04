# Brainstorm Report: Portfolio Single-Page Rebuild + Auto Deploy

- Date: 2026-07-04 14:03 (+07)
- Session: /ck:brainstorm — investigate site source + design new portfolio
- Status: APPROVED (PA1 chosen by user)

## 1. Problem Statement

Câu hỏi gốc: source của https://hieutv-dng.github.io/ nằm đâu, có phải repo `flutter_portfolio`?

**Kết quả điều tra (evidence-based):**

| Fact | Evidence |
|---|---|
| Site live serve từ repo `hieutv-dng/hieutv-dng.github.io` (user site, branch `master`) | GitHub Pages convention, repo tồn tại, public |
| Repo đó CHỈ chứa build output `flutter build web`, không có source Dart | File tree: `main.dart.js` (~1.7MB), `flutter_service_worker.js`, `assets/`, `version.json` |
| Project gốc tên `hieutv`, build + push 1 lần duy nhất 27/06/2021 (7 commits cùng ngày) | `version.json: app_name=hieutv`; commit log |
| KHÔNG phải `flutter_portfolio`: repo này tạo 19/01/2024 (3 năm sau), chỉ có counter boilerplate, `has_pages=false`, không chung git history | `gh api` metadata + local scan |
| Source Dart 2021 không tồn tại ở bất kỳ repo nào trên account (đã rà ~50 repos kể cả private, sort createdAt) | `gh repo list --source` |
| Assets cũ cứu được từ repo github.io: `IMG_7344.jpg`, `bg.jpeg`, icons svg (behance/dribbble/github/linkedin/twitter/check/download) | Tree `assets/assets/` |

→ Vấn đề thực: portfolio live đã stale từ 2021, source mất, repo `flutter_portfolio` được tạo 2024 để làm lại nhưng chưa bắt đầu. Cần: xây portfolio mới trong repo này + pipeline deploy bền vững (không phụ thuộc máy cá nhân như 2021).

## 2. Requirements (user decisions — KHÔNG tự đảo ngược)

1. **Phạm vi**: multi-section đầy đủ — Hero, About/Skills, Projects, Experience, Contact.
2. **Deploy**: GitHub Actions tự động → push build sang repo `hieutv-dng.github.io` (giữ root domain).
3. **Nội dung**: placeholder có cấu trúc + tái dùng assets 2021; user thay nội dung thật sau.
4. **Ngôn ngữ**: tiếng Anh, KHÔNG l10n.

### Acceptance criteria
- `flutter analyze` = 0 issues (ruleset nghiêm của repo, không nới lỏng).
- `flutter test` pass (thay `test/widget_test.dart` counter bằng tests mới).
- CI: push master → analyze + test + build + deploy tự động; site live tại root domain.
- Responsive 3 breakpoints (mobile/tablet/desktop), animations chạy mượt.
- Thay nội dung thật = chỉ sửa data file, không đụng UI code.

### Scope boundary (OUT)
- Không mobile app build (web-only, repo chỉ có `web/`).
- Không CMS/backend, không GitHub API fetch, không l10n, không blog.
- Nội dung thật (bio/CV/projects) do user cung cấp sau — ngoài scope round này.

## 3. Evaluated Approaches

| # | Approach | Pros | Cons | Verdict |
|---|---|---|---|---|
| PA1 | Lean single-page: 1 route cuộn 5 sections, no state-mgmt package, data tĩnh `lib/src/data/`, flutter_animate | Ít dependency (YAGNI/KISS), dễ qua lint nghiêm, trải nghiệm cuộn liền mạch, ship nhanh | Section không có URL riêng | **CHOSEN** |
| PA2 | Multi-route go_router (/about, /projects…) | URL shareable | Thêm dependency + routing phức tạp trên Pages, giá trị thấp cho 5 sections tĩnh | Rejected |
| PA3 | Clone template (The Flutter Way style) | Thấy kết quả nhanh | Code 2021-era vỡ hàng loạt trước lint nghiêm, thiết kế đụng hàng | Rejected |

## 4. Final Solution (PA1)

### Kiến trúc
- Single route, `SingleChildScrollView`/`CustomScrollView` + nav bar scroll-to-section (GlobalKey/ScrollController).
- State: `setState` only. Content = const models trong `lib/src/data/portfolio_data.dart`.
- Responsive: breakpoint helper (`< 768` mobile, `< 1024` tablet, còn lại desktop) + `LayoutBuilder`.
- Theme: Material 3, `ColorScheme.fromSeed` (giữ convention CLAUDE.md), dark-first tuỳ design phase.
- File names: snake_case (Dart convention, lint `file_names`).

### Cấu trúc thư mục dự kiến
```
lib/
  main.dart
  src/
    app.dart                    # MaterialApp + theme
    theme/app_theme.dart
    data/portfolio_data.dart    # models + placeholder content (single source of truth)
    utils/breakpoints.dart
    ui/
      home/home_page.dart       # scaffold, scroll, nav
      sections/{hero,about,projects,experience,contact}_section.dart
      widgets/                  # section_container, social_icon_button, ...
assets/
  images/   # IMG_7344.jpg, bg.jpeg (từ repo github.io)
  icons/    # svg 2021
```

### Dependencies mới (tối thiểu)
- `flutter_animate` — entrance/scroll-reveal animations.
- `flutter_svg` — render icons svg 2021.
- Font: bundle file font trong `assets/fonts/` (quyết định cụ thể ở design phase; tránh runtime-fetch).

### Deploy pipeline (`.github/workflows/deploy.yml`)
- Trigger: push `master` + `workflow_dispatch`.
- Steps: checkout → `subosito/flutter-action` (stable 3.41.x) → `flutter pub get` → `flutter analyze` → `flutter test` → `flutter build web --release` (base-href `/` mặc định, đúng root domain) → `peaceiris/actions-gh-pages@v4` với `deploy_key`, `external_repository: hieutv-dng/hieutv-dng.github.io`, `publish_branch: master`, `publish_dir: ./build/web`.
- **Manual one-time setup (user)**: tạo SSH keypair; public key → Deploy key (write) trên repo `hieutv-dng.github.io`; private key → secret `ACTIONS_DEPLOY_KEY` trên repo `flutter_portfolio`.
- Site 2021 KHÔNG mất: nằm nguyên trong git history repo github.io (không dùng `force_orphan`).

## 5. Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Flutter web bundle nặng (~1.5–2MB), SEO kém | Trade-off đã chấp nhận; loading splash trong `index.html` + meta tags (title/description/og) đầy đủ |
| Deploy key setup sai → CI fail ở bước push | Bước manual có checklist; `workflow_dispatch` để test deploy độc lập |
| Lint nghiêm vỡ code | Viết chuẩn từ đầu: const, directives_ordering, return types; analyze chạy trong CI |
| `test/widget_test.dart` break khi thay `main.dart` | Plan phải thay test cùng phase đầu |
| flutter_animate/flutter_svg compat Flutter 3.41 | Chọn version mới nhất thoả SDK `>=3.2.5 <4.0.0` khi cook |

## 6. Success Metrics
- CI xanh end-to-end; site live root domain, đủ 5 sections.
- 0 analyze issues; tests pass; responsive đạt 3 breakpoints.
- Đổi nội dung placeholder → thật: 1 file (`portfolio_data.dart`) + assets.

## 7. Next Steps
1. `/ck:plan` với report này → phases: scaffold structure/theme → sections UI + responsive → animations → assets + data → CI/CD + deploy key setup → tests.
2. User chuẩn bị dần nội dung thật (bio, projects, CV pdf) — không chặn implementation.

## Unresolved Questions
- Design direction cụ thể (palette, font, dark/light) — quyết ở design/plan phase.
- Nội dung thật thay placeholder — user cung cấp sau.
