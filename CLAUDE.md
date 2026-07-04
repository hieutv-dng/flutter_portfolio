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
flutter analyze                    # static analysis against the strict rule set below
dart format .                      # format
flutter test                       # run all tests
flutter test test/widget_test.dart # run a single test file
flutter test --name "<substr>"     # run tests whose name matches a substring
flutter build web                  # production web build -> build/web
```

Toolchain: Flutter 3.41.x (stable), Dart SDK constraint `>=3.2.5 <4.0.0`.

## Linting

`analysis_options.yaml` is **not** the default `flutter_lints` config — it is a large, hand-curated
rule set mirroring the Flutter framework's own analysis options, so it is considerably stricter
than a typical app. Treat `flutter analyze` output as the source of truth for style; do not relax
rules in this file to make code pass. Notable overrides: `todo` and `deprecated_member_use_from_same_package`
are ignored, and `avoid_print` is a warning (not an error).

## Conventions to preserve when building out

- `const` is enforced heavily (`prefer_const_constructors`, `prefer_const_declarations`,
  `prefer_const_literals_to_create_immutables`). Add `const` wherever the analyzer asks.
- Import ordering is enforced (`directives_ordering`); keep `dart:`, `package:`, then relative
  imports grouped and sorted.
- Return types are required on all declarations (`always_declare_return_types`).
- Material 3 is enabled (`useMaterial3: true`) with a `ColorScheme.fromSeed` theme — keep new
  screens on the same theming approach.
