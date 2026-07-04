---
phase: 6
title: "CI/CD Deploy"
status: pending
effort: "0.5d"
priority: P1
dependencies: [5]
---

# Phase 6: CI/CD Deploy

## Overview

Workflow GitHub Actions: push `master` → analyze + test + build web → push `build/web` sang repo `hieutv-dng/hieutv-dng.github.io` (branch `master`) bằng deploy key. Gồm bước manual một lần của user (tạo key) và verify site live.

## Requirements

- Functional: CI xanh end-to-end; site mới live tại https://hieutv-dng.github.io/ ; `workflow_dispatch` chạy được độc lập
- Non-functional / an toàn:
  - KHÔNG `force_orphan` — giữ nguyên git history repo github.io (site 2021 khôi phục được)
  - Secret không bao giờ in ra log; private key không nằm trong repo/máy sau khi setup
  - Concurrency: deploy sau cancel deploy trước đang chạy

## Architecture

`.github/workflows/deploy.yml` (1 job `build-and-deploy`, ubuntu-latest):

```yaml
name: Deploy to hieutv-dng.github.io
on:
  push: {branches: [master]}
  workflow_dispatch:
concurrency: {group: pages-deploy, cancel-in-progress: true}
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: {channel: stable, flutter-version: <pin đúng version local `flutter --version`>, cache: true}
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build web --release   # base-href mặc định "/" — đúng root domain
      - uses: peaceiris/actions-gh-pages@v4
        with:
          deploy_key: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          external_repository: hieutv-dng/hieutv-dng.github.io
          publish_branch: master
          publish_dir: ./build/web
```

## Related Code Files

- Create: `.github/workflows/deploy.yml`
- Verify (không sửa): `.gitignore` đã ignore `build/`

## Implementation Steps

1. Pin version: chạy `flutter --version` local → điền vào workflow
2. Viết `deploy.yml` như trên
3. **Manual (user, một lần)** — checklist đưa user làm, KHÔNG tự động hoá bước này:
   - [ ] `ssh-keygen -t ed25519 -C "actions-deploy@flutter_portfolio" -f /tmp/portfolio_deploy_key -N ""`
   - [ ] Repo `hieutv-dng.github.io` → Settings → Deploy keys → Add: nội dung `.pub`, tick **Allow write access**
   - [ ] Repo `flutter_portfolio` → Settings → Secrets and variables → Actions → New secret `ACTIONS_DEPLOY_KEY` = nội dung private key
   - [ ] Xoá key local: `rm /tmp/portfolio_deploy_key*`
4. Commit + push workflow (theo conventional commit, không AI reference)
5. Chạy `workflow_dispatch` lần đầu (hoặc push) → theo dõi `gh run watch`
6. Verify: mở https://hieutv-dng.github.io/ (hard reload — service worker cũ 2021 có thể cache; xác nhận `flutter_service_worker.js` mới thay bản cũ, cần Ctrl+Shift+R lần đầu)
7. Ghi chú rollback vào README (ngắn): revert commit trên repo github.io hoặc re-run deploy từ commit cũ

## Success Criteria

- [ ] Push master → run xanh: analyze, test, build, deploy đủ 4 bước
- [ ] Site mới live root domain; site 2021 vẫn nằm trong history repo github.io
- [ ] Secret hoạt động, không lộ trong log; không file key nào bị commit

## Risk Assessment

- Service worker 2021 cache site cũ cho khách quay lại: SW mới của Flutter tự update sau reload — chấp nhận; verify bằng hard reload + tab ẩn danh
- Deploy key sai/thiếu write: run fail ở bước cuối với lỗi permission — checklist bước 3 làm lại; test độc lập bằng `workflow_dispatch`
- Push lên master repo này khi CI chưa sẵn: workflow chỉ thêm ở phase cuối — các phase trước không trigger deploy vì file workflow chưa tồn tại
- Flutter version CI lệch local: pin exact version bước 1; nâng cấp sau này = sửa 1 dòng
