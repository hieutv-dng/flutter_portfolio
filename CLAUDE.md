# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

`flutter_portfolio` is a Flutter app scaffolded from the default template — it currently
contains only the boilerplate counter app in `lib/main.dart`. Per `README.md`, the intended
build-out is a **responsive and animated portfolio website & app** (Flutter UI), so most
feature work starts from an empty slate rather than an existing architecture.

- Only the **web** platform is set up (`web/`). There are no `android/`, `ios/`, `macos/`,
  `windows/`, or `linux/` runner directories yet. Run `flutter create --platforms=<p> .` to
  add a target before building for it.
- `test/widget_test.dart` still tests the default counter; it will break once `main.dart` is
  replaced, so update it alongside UI changes.

## Commands

```bash
flutter pub get                    # install dependencies
flutter run -d chrome              # run on web (default configured port is 5010, see .vscode/launch.json)
flutter analyze                    # static analysis (flutter_lints, see below)
dart format .                      # format
flutter test                       # run all tests
flutter test test/widget_test.dart # run a single test file
flutter test --name "<substr>"     # run tests whose name matches a substring
flutter build web                  # production web build -> build/web
```

Toolchain: Flutter 3.41.x (stable), Dart SDK constraint `^3.11.5`.

## Linting

`analysis_options.yaml` uses the standard **`flutter_lints`** ruleset
(`include: package:flutter_lints/flutter.yaml`). Treat `flutter analyze` output as the source of
truth for style. When a convention needs enforcing or relaxing, add or override it under
`linter.rules` in that file rather than sprinkling `// ignore:` comments.

## Conventions to preserve when building out

- `const` is encouraged — `flutter_lints` enables `prefer_const_constructors`,
  `prefer_const_declarations`, and `prefer_const_literals_to_create_immutables`. Add `const`
  wherever the analyzer asks.
- Import ordering and explicit return types are no longer lint-enforced under `flutter_lints`; keep
  `dart:`, `package:`, then relative imports grouped and declare return types, for consistency.
- Material 3 is the framework default; theme via `ColorScheme.fromSeed` (no explicit
  `useMaterial3` flag needed) — keep new screens on the same theming approach.
