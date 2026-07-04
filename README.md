# flutter_portfolio

Responsive and Animated Portfolio Website &amp; App - Flutter UI

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Deployment

Push to `master` triggers `.github/workflows/deploy.yml`: analyze → test →
`flutter build web --release` → publish `build/web` to
[`hieutv-dng/hieutv-dng.github.io`](https://github.com/hieutv-dng/hieutv-dng.github.io)
(`master` branch) via deploy key. Site live at <https://hieutv-dng.github.io/>.
Can also run manually via the workflow's **Run workflow** button (`workflow_dispatch`).

### Rollback

The deploy never uses `force_orphan`, so the `github.io` repo keeps full history.
To roll back: on `hieutv-dng.github.io`, `git revert` the bad deploy commit (or reset
to a known-good one) and push — GitHub Pages redeploys automatically. Alternatively,
re-run this workflow from an earlier green commit to rebuild and republish.