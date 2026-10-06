# Repository Guidelines

## Project Structure & Module Organization

This repository is a Flutter application using Dart and GetX. Application code lives in `lib/`:

- `lib/screens/` contains pages grouped by feature (`auth`, `home`, `map`, `order`, `profile`, `tailor`).
- `lib/controllers/` contains GetX state and API orchestration.
- `lib/models/` contains JSON-backed domain models.
- `lib/data/` and `lib/services/` contain API clients, repositories, and static data.
- `lib/widgets/` contains reusable UI components; shared colors and constants are in `lib/core/`.
- `assets/` stores images, banners, category artwork, logos, and fonts. Keep existing banner assets unchanged unless a task explicitly requests replacements.
- `test/` contains Flutter tests, with `test/widget_test.dart` as the current baseline.

## Build, Test, and Development Commands

Run these from the repository root:

```bash
flutter pub get       # install dependencies
flutter run           # run on a connected device or emulator
flutter analyze       # check Dart and Flutter diagnostics
flutter test          # run the test suite
flutter build apk     # create an Android release artifact
```

Use a configured `.env` for API settings; do not commit secrets.

## Coding Style & Naming Conventions

Use the repository formatter (`dart format .`) and the rules in `analysis_options.yaml`. Use two-space indentation, `lower_snake_case.dart` filenames, `PascalCase` classes/widgets, and `camelCase` members. Prefer `const` constructors and values where possible. Reuse `AppColors`, `AppTheme`, and existing widgets instead of duplicating styles. The current UI direction is flat, clean, dark green, and uses restrained 10–12px corner radii without drop shadows.

## Testing Guidelines

Name tests with the behavior under test, such as `home_screen_shows_tailors`. Run `flutter test` before submitting UI or controller changes and run `flutter analyze` for every Dart change. Add focused widget or controller coverage when behavior changes; visual-only changes can rely on analyzer checks and manual device review.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, lowercase summaries with a category-like prefix, for example `feat: ...`, `style: ...`, or `chore: ...`. Keep commits focused. Pull requests should explain the user-visible change, list affected pages, link the related issue when available, and include screenshots or a short recording for UI changes. Mention validation commands and any configuration or migration steps.
