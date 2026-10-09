# AGENTS.md

Flutter + GetX app. Entry: `lib/main.dart` → `InitialBinding` → `AppRoutes.onGenerateRoute`.

## Commands

```bash
flutter pub get
flutter analyze          # gate for every Dart change
flutter test test/<name>_test.dart   # single file; full `flutter test` also works
dart format .
```

## Wiring (non-obvious)

- Routing uses `onGenerateRoute` in `lib/routes/app_routes.dart` inside a `GetMaterialApp` — add routes there, not via `GetPage` list.
- DI lives in `lib/bindings/initial_binding.dart` (`ApiService`, `AuthController`, `ProfileController`, permanent `SliderController`/`TailorController`). Register new shared controllers there with `Get.put`, don't instantiate inline in widgets.
- Screen state is per-feature GetX controllers in `lib/controllers/`; API calls go through `lib/data/api_service.dart` (`Token` auth header, token in `SharedPreferences` under `auth_token`).

## Env / backend gotcha

- `main.dart` calls `dotenv.load(fileName: ".env")` and crashes if `.env` is missing. `.env` is gitignored AND listed as a flutter asset in `pubspec.yaml`. Required key: `URL_API=http://<host>:8000` (fallback `http://127.0.0.1:8000` in `ApiService.onInit`).
- On Android emulator the API base must be reachable (LAN IP or `10.0.2.2`); only image URLs get auto-rewritten from `localhost`/`127.0.0.1` (`ApiService.getImageUrl`), the API base does not.

## UI conventions

- Reuse `AppColors` (`lib/core/constants/app_colors.dart`, primary dark green `0xFF173834`) and `AppTheme.light` (`lib/theme/app_theme.dart`): flat, `elevation: 0`, ~10px radii. Don't introduce new palettes or shadows.
- Reusable widgets live in `lib/widgets/`; feature screens in `lib/screens/<auth|home|map|order|tailor|chat|profile|...>/`.

## Map module

- Logic centralized in `MapControllerX` (`lib/controllers/map_controller.dart`) + `lib/services/map_repository.dart`. Tuned constants: position stream `distanceFilter: 10m`, arrival threshold `50m`, search debounce `800ms`. Don't retune without cause; location permission must be granted or map shows nothing.

## Testing

- `test/widget_test.dart` is the stale default counter smoke test — it does not match this app (needs `.env` + Get bindings) and fails. Don't rely on it; write focused widget/controller tests for behavior changes instead.

## i18n (official ARB)

- Strings live in `lib/l10n/app_en.arb` (template) + `app_id.arb`; config in `l10n.yaml` (output `lib/l10n/generated/`, do NOT edit generated files).
- `flutter gen-l10n` re-runs automatically on build; run it manually after editing ARB. Add new keys to BOTH arb files or generation fails.
- Access via `AppLocalizations.of(context)` (non-nullable). Inside GetX `Obx` builders there is no context — wrap with `Builder` first.
- Language state: `LocaleController` (`lib/controllers/locale_controller.dart`), persisted as `app_locale` in SharedPreferences, defaults to device locale if `en`/`id`. `changeLocale` sets BOTH the Rx and `Get.locale` — GetMaterialApp resolves `Get.locale ?? locale`, so the `locale:` param alone is ignored after startup. Never use `Get.forceAppUpdate()` (performReassemble breaks tests/release).

## Commits

Observed style: short lowercase imperative with prefix, e.g. `feat: ...`, `style: ...`, `chore: ...`, `refactor: ...`, `docs: ...`. Keep commits focused; UI PRs include affected pages + screenshot/recording.
