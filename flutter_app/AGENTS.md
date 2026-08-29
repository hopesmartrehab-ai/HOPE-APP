# AGENTS.md

This file guides AI coding agents working in the HOPE Flutter repository based on the current project structure and implementation patterns.

## Project Overview

HOPE is a Flutter rehabilitation app for patient session intake, questionnaire check-in, glove-driven assessment and exercise results, video capture/upload, practitioner session review, and a simple dashboard. The app starts in `lib/main.dart`, initializes Hydrated Bloc storage, local storage, Easy Localization, and GetIt registrations, then launches `lib/my_app.dart`. The active user flow is centered around `SessionProvider`, `Navigator.push`-based screens, and the HTTP client in `lib/core/old_core/services/api_service.dart`.

The repository is feature-first but mixed in maturity. The patient and practitioner session flows under `lib/features/screens/` are the clearest active product paths. At the same time, the project still carries newer generic `core/network_services`, `core/theme`, and `features/login/` scaffolding that is only partially integrated into the live HOPE flow. Do not assume the codebase is fully migrated to one architecture style.

## Architecture

### Folder Structure

```text
lib/
|-- main.dart                                      # Bootstrap: HydratedBloc, localization, storage, DI
|-- my_app.dart                                    # MaterialApp, theme mode, DebugOverlay, root screen
|-- config.dart                                    # API base URL and default glove device id
|-- core/
|   |-- connection/                                # Connectivity abstraction
|   |-- constants/                                 # Locale keys, API keys, localization constants, generated assets constants
|   |-- di/                                        # GetIt registrations
|   |-- enums/                                     # Shared enums
|   |-- extensions/                                # Small shared extensions
|   |-- functions/                                 # Utility functions
|   |-- helper/                                    # Validators, status colors, version/device helpers, API message localization
|   |-- local_storage/                             # SharedPreferences + FlutterSecureStorage facade
|   |-- modules/                                   # Lightweight shared response model
|   |-- network_services/                          # Dio-based generic API layer and token interceptor
|   |-- old_core/
|   |   |-- constants/                             # Demo users and old constants
|   |   |-- debug/                                 # Debug overlay, request logs, logger
|   |   |-- services/                              # Active HOPE API service, exercise videos, video upload service
|   |   `-- theme/                                 # HopeColors and older screen-level theme helpers used by screens
|   |-- resources/                                 # Bloc observer and debug print helpers
|   |-- services/                                  # Upload and image helpers
|   |-- shared_widgets/                            # Reusable fields, buttons, app bar, dialogs, toasts, image helpers
|   |-- theme/                                     # AppThemes, colors, theme cubit, theme extensions
|   `-- utils/                                     # Route placeholder and enums
|-- features/
|   |-- login/                                     # Partially scaffolded generic auth structure, not a current live HOPE flow
|   |   |-- data/
|   |   |   |-- local_data_source/
|   |   |   |-- logic/
|   |   |   `-- models/
|   |   |-- domain/
|   |   |   |-- entities/
|   |   |   |-- params/
|   |   |   `-- repos/
|   |   `-- presentation/
|   |       |-- pages/
|   |       `-- widgets/
|   |-- models/                                    # Session, assessment result, exercise result
|   |-- screens/
|   |   |-- welcome_screen.dart                    # App entry screen after bootstrap
|   |   |-- role_selection_screen.dart             # Patient vs practitioner split
|   |   |-- dashboard/                             # Shared patient/practitioner dashboard UI
|   |   |-- patient/                               # Start session, questionnaire, waiting, results, patient shell
|   |   `-- practitioner/                          # Session list, detail, practitioner shell
|   |-- state/                                     # SessionProvider and locale provider
|   `-- widgets/                                   # Session/video/result widgets reused by active screens
assets/
|-- flags/                                         # App logo
|-- icons/                                         # App icon
|-- images/                                        # Questionnaire/exercise/help imagery
`-- translations/                                 # `en.json` and `ar.json`
test/
`-- widget_test.dart                               # Minimal smoke test
```

### Layers

| Layer | Path | Responsibility | Must not do |
| --- | --- | --- | --- |
| Bootstrap | `lib/main.dart`, `lib/my_app.dart` | Initialize app-wide services, theme mode, localization, debug overlay, and root widget tree | Hold session business logic or screen-specific state |
| Active feature state | `lib/features/state/` | Own app/session flow state, polling, session history loading, questionnaire submit, and video upload orchestration | Render large UI trees or hard-code screen layout |
| Active presentation | `lib/features/screens/`, `lib/features/widgets/` | Patient/practitioner screens, navigation, form inputs, charts, result cards, and screen-local interaction state | Reimplement HTTP calls inside widgets |
| Active data models | `lib/features/models/` | Parse backend session, assessment, and exercise payloads into app-readable models | Depend on screen widgets |
| Active infrastructure | `lib/core/old_core/services/`, `lib/config.dart` | Perform REST calls, glove simulation, and video upload against the current HOPE backend | Depend on presentation widgets |
| Shared app infrastructure | `lib/core/local_storage/`, `lib/core/di/`, `lib/core/connection/`, `lib/core/resources/` | Storage, DI, connectivity abstraction, logging, bloc observer | Become feature-specific dumping grounds |
| Shared UI system | `lib/core/shared_widgets/`, `lib/core/theme/`, `lib/core/old_core/theme/` | Reusable visual building blocks, app theme data, old Hope color palette helpers | Duplicate one-off feature widgets that belong under `features/` |
| Transitional generic layer | `lib/core/network_services/`, `lib/features/login/` | Generic Dio-based networking and placeholder auth/domain structure for future or partial migration | Be assumed as the authoritative pattern for current session flow |

### Dependency Direction

| Rule | Meaning |
| --- | --- |
| `screens -> SessionProvider` | Active patient and practitioner flows should read and mutate session state through `Provider` |
| `SessionProvider -> old_core/services/api_service.dart` | Session lifecycle, polling, delete, and questionnaire calls go through the old HTTP client |
| `SessionProvider -> features/models` | Provider logic consumes typed `Session`, `SessionSummary`, `AssessmentResult`, and `ExerciseResult` models |
| `screens -> features/widgets + core/shared_widgets` | Compose screens from shared widgets before creating new UI primitives |
| `my_app.dart -> ThemeCubit` | Theme mode is Bloc-driven at the app shell level |
| `core/network_services -X-> active session screens` | The Dio-based generic API layer is not the default path for the live HOPE session flow |
| `features/login -X-> patient/practitioner flow` | The generic login scaffolding should not be treated as a dependency of the active session feature set |
| `feature -> core` | Features may reuse localization, helpers, storage, theme, shared widgets, and services from `core` |

### Architecture Patterns

| Pattern | Current implementation |
| --- | --- |
| Feature-first organization | Product work is organized under `lib/features/` |
| Provider-led session flow | `SessionProvider` is the main state owner for active assessment/exercise flows |
| Mixed state management | `provider` drives session flows, while `flutter_bloc` and `hydrated_bloc` are primarily used for app-level theme persistence |
| Navigator-based routing | Screens mostly navigate with `Navigator.push` and `MaterialPageRoute`; `AppRoute` is currently a placeholder, not the main router |
| Typed REST parsing | `features/models/` holds typed backend models instead of raw map usage in screens |
| Legacy + transitional infrastructure | `core/old_core` still powers the live API flow, while `core/network_services` and `features/login` reflect a broader architecture migration that is not complete |
| Localization via constants | User-facing text is expected to go through `LocaleKeys.<key>.tr()` with translation JSON files in `assets/translations/` |
| Shared widget reuse | Buttons, form fields, dialogs, toasts, and media widgets are centralized in `core/shared_widgets/` and `features/widgets/` |
| Debug-friendly runtime | `DebugOverlay`, `LoggingHttpClient`, `DebugLogStore`, and `AppLogger` are built into the active session workflow |

### Current Architecture Notes

| Area | Current state |
| --- | --- |
| App entry | `main.dart` initializes Easy Localization for `en` and `ar`, HydratedBloc storage, local storage, and GetIt before running `MyApp` |
| Root app shell | `my_app.dart` wraps the app in `MultiBlocProvider`, uses `ThemeCubit`, and sets `DebugOverlay(child: WelcomeScreen())` as the home screen |
| Routing | Most flows use direct `Navigator.push`; `lib/core/utils/app_route.dart` is effectively unused right now |
| Session flow | `SessionProvider` owns session creation, automatic glove linking, assessment polling, questionnaire submission, exercise polling, session reset, and practitioner session history |
| Backend base URL | `lib/config.dart` points the live session flow to `https://jk7o08xdb6.execute-api.eu-west-3.amazonaws.com/prod` with hard-coded `defaultDeviceId = 'hope-glove-01'` |
| Active API client | `lib/core/old_core/services/api_service.dart` uses `package:http`, wraps network failures into `NoNetworkException`, and includes glove simulation plus video upload URL retrieval |
| Transitional API client | `lib/core/network_services/api_service.dart` builds a Dio client with token and logging interceptors, but it is not the main API path for the current HOPE session screens |
| Login feature | `lib/features/login/` mostly contains placeholders and should not be used as proof that auth is fully implemented in this app |
| Localization | `LocaleKeys` contains many keys, but the active app is configured with two locales only: English and Arabic |
| Theme system | Active screens often import `lib/core/old_core/theme/app_theme.dart` for `HopeColors`, while the app shell theme comes from `lib/core/theme/styles/app_theme.dart` |
| Assets | The repository contains `assets/images/`, `assets/icons/`, `assets/flags/`, and `assets/translations/`; there is no confirmed `assets/help/` directory even though one screen references it |
| Tests | `test/widget_test.dart` is a minimal smoke test and is not strong feature coverage |
| Lints | `analysis_options.yaml` keeps Flutter lints, prefers `const`/`final`, and explicitly ignores `depend_on_referenced_packages` and `use_build_context_synchronously` |

## Tech Stack

| Area | Technology |
| --- | --- |
| Framework | Flutter with Dart SDK `^3.8.1` |
| Active state management | `provider`, `ChangeNotifier`, `notifyListeners()` |
| App-level state persistence | `flutter_bloc`, `hydrated_bloc`, `equatable` |
| Networking | `http` for the live session flow, `dio` present for transitional generic networking |
| DI | `get_it` |
| Storage | `shared_preferences`, `flutter_secure_storage`, `path_provider` |
| Localization | `easy_localization`, `intl` |
| Media and device | `camera`, `video_player`, `youtube_player_flutter`, `device_info_plus`, `package_info_plus`, `url_launcher` |
| UI and charts | Material 3, `fl_chart`, `auto_size_text`, `badges`, `dotted_border`, `flutter_svg`, `cached_network_image`, `loading_animation_widget`, `smooth_page_indicator`, `google_fonts`, `elegant_notification` |
| Connectivity | `connectivity_plus` |
| Debug tooling | `device_preview`, Talker packages, custom debug overlay/log store |

## Conventions

### Common Commands

| Command | Purpose |
| --- | --- |
| `flutter pub get` | Install dependencies |
| `flutter run` | Run the app on a device or emulator |
| `flutter analyze` | Run analyzer checks across the project |
| `flutter analyze lib/<path>` | Run focused analysis on changed files or feature folders |
| `dart format lib test` | Format project Dart code |
| `flutter test` | Run the existing widget test suite |
| `git diff --check` | Catch whitespace issues before handoff |

### Feature Layout

Use the active patient/practitioner flow as the main reference for feature work in this repository.

```text
features/
|-- models/                      # Backend-facing typed models
|-- screens/
|   |-- <feature_area>/          # Route-level screens grouped by role or area
|   `-- <screen>.dart
|-- state/                       # ChangeNotifier providers and app flow state
`-- widgets/                     # Reusable widgets tied to active HOPE flows
```

When the task touches the existing session flow, prefer extending:
- `features/state/session_provider.dart`
- `features/models/`
- `features/screens/patient/`
- `features/screens/practitioner/`
- `features/widgets/`

Do not introduce a deep `domain/data/presentation` split for a small session-flow change unless that nearby area already follows it and the user asked for structural refactoring. The current live flow is simpler and Provider-centric.

### Active Flow of Integration

| Step | Layer | Target | What to add |
| --- | --- | --- | --- |
| 1 | Config | `lib/config.dart` | Add or update the base URL or default device setting only when the backend contract truly changed |
| 2 | Data model | `lib/features/models/` | Parse new backend fields into typed models first |
| 3 | Infrastructure | `lib/core/old_core/services/api_service.dart` | Add the HTTP request method and map network/API failures consistently |
| 4 | State | `lib/features/state/session_provider.dart` | Expose the new async action, loading transition, or derived state |
| 5 | Presentation | `lib/features/screens/...` or `lib/features/widgets/...` | Connect UI to provider state, localization keys, and result rendering |
| 6 | Localization | `lib/core/constants/locale_keys.dart` + `assets/translations/*.json` | Add any new user-facing keys in both locale files |
| 7 | Verification | Analyzer/tests/manual run | Format, analyze changed files, and sanity-check the flow in the app when safe |

### File, Directory, and Dart Naming

| Type | Convention | Example |
| --- | --- | --- |
| Directories/files | `snake_case` | `session_list_screen.dart`, `session_provider.dart` |
| Class names | `PascalCase` | `SessionProvider`, `PractitionerShellScreen` |
| Methods/variables | `lowerCamelCase` | `startPollingForExercise`, `_pollCount` |
| Screen files | `<name>_screen.dart` | `questionnaire_screen.dart` |
| Shell/root screen files | `<role>_shell_screen.dart` | `patient_shell_screen.dart` |
| Provider/state files | `<feature>_provider.dart` or `<feature>_cubit.dart` | `session_provider.dart`, `theme_cubit.dart` |
| Model files | Singular concept names in `snake_case` | `session.dart`, `assessment_result.dart`, `exercise_result.dart` |
| Shared widget files | Name by UI responsibility | `custom_button.dart`, `result_card.dart`, `language_toggle.dart` |
| Constants files | Shared noun-based names | `locale_keys.dart`, `api_keys.dart`, `assets_constants.dart` |

### API, Model, Localization, and Error Rules

| Rule | Required behavior |
| --- | --- |
| Active session API path | Prefer `lib/core/old_core/services/api_service.dart` for current HOPE session endpoints unless the task is explicitly about migrating to the Dio layer |
| Base URL usage | Use `apiBaseUrl` from `lib/config.dart`; do not hard-code endpoint roots inside screens |
| Models first | Parse new session payload fields in `features/models/` before consuming them in widgets |
| Error types | Surface network failures through `NoNetworkException` and API failures through `ApiException` in the active HTTP client |
| Provider ownership | Let `SessionProvider` translate API methods into user-facing flow state instead of calling HTTP directly from screens |
| User-facing text | Use `LocaleKeys.<key>.tr()` for visible strings |
| Locale parity | When adding a translation key, update `assets/translations/en.json` and `assets/translations/ar.json` together |
| Existing locale scope | Do not document or implement extra active locales unless the app is actually configured for them |
| Backend messages | If the backend returns meaningful text through existing flow plumbing, prefer showing it instead of inventing generic replacements |
| JSON keys | Reuse constants where they already exist, but do not force `ApiKeys` into places where the current codebase is already using typed direct field parsing |
| Screen errors | Keep transient UI feedback in snackbars, toasts, dialogs, or existing shared feedback widgets, not inside low-level service classes |

### Feature and Module Responsibilities

| Area | Responsibility |
| --- | --- |
| `features/state/session_provider.dart` | Session lifecycle orchestration, polling, questionnaire, video upload, session history, and derived device/accumulation state |
| `features/screens/patient/` | Patient-first flow from session start through assessment, questionnaire, exercise wait, and results |
| `features/screens/practitioner/` | Practitioner session list, detail view, delete flow, and practitioner dashboard shell |
| `features/screens/dashboard/` | Shared role-based dashboard visualization |
| `features/widgets/` | Reusable active-flow widgets for scores, videos, errors, and result cards |
| `core/shared_widgets/` | App-wide building blocks that are not specific to one session screen |
| `core/old_core/debug/` | Request logging, state transition tracing, and in-app debug overlay support |
| `core/theme/` | App-level light/dark theme definition and persistence |
| `core/old_core/theme/` | Legacy Hope palette helpers still imported by many active screens |
| `features/login/` | Transitional scaffold only; do not expand it casually unless the task is specifically about auth architecture |

## Do

| Do | Why |
| --- | --- |
| Inspect the active patient or practitioner flow before coding | The live architecture is simpler than the transitional folders suggest |
| Reuse `SessionProvider` for session-state changes | It is the real orchestration layer for the current app |
| Extend `features/models/` before adding UI work for new backend fields | Typed parsing keeps screens cleaner |
| Reuse `core/shared_widgets/` and `features/widgets/` before making new primitives | The project already centralizes common controls and display cards |
| Keep navigation consistent with nearby screens | Most active flows use direct `Navigator.push` and `MaterialPageRoute` |
| Use `LocaleKeys` and update both translation files together | The active app is localized in English and Arabic |
| Respect the split between `core/theme/` and `core/old_core/theme/` | Many screens still rely on `HopeColors` even though the app shell uses `AppThemes` |
| Preserve debug and logging hooks when touching provider or service logic | `DebugOverlay`, `AppLogger`, and request logging are part of the current workflow |
| Run formatting and focused analysis after edits | The project has several transitional layers and warning drift is easy |
| Call out incomplete migrations when they matter to the task | Agents should not silently normalize the repo into an architecture it does not yet have |

## Don't

| Don't | Why |
| --- | --- |
| Do not assume `core/network_services` is the default API path for active session screens | The live HOPE flow still uses `core/old_core/services/api_service.dart` |
| Do not route new session logic directly from widgets to HTTP calls | Keep async orchestration in `SessionProvider` |
| Do not invent a full clean-architecture slice for a small UI or provider change | The surrounding active code does not use that structure |
| Do not treat `features/login/` as a finished production auth module | It is mostly placeholder scaffolding today |
| Do not hard-code user-facing strings in screens | Use localization keys and translation JSON |
| Do not add extra locales, Firebase, CI, or backend tooling in documentation unless they are actually present | This repository should be described as it exists now |
| Do not remove old theme or debug utilities casually | Active screens still depend on them |
| Do not rely on `AppRoute` for new navigation assumptions | It is currently a placeholder, not the routing backbone |
| Do not move shared UI into `core/` unless it is reused broadly | Session-specific widgets should stay under `features/widgets/` |
| Do not ignore asset-path reality | If an asset directory is missing, fix the reference or asset setup instead of documenting imaginary files |

## Common Mistakes

| Mistake | Correct approach |
| --- | --- |
| Wiring a new session endpoint into the Dio client because `core/network_services/` looks newer | For current HOPE session work, add the endpoint to `core/old_core/services/api_service.dart` unless the task is an explicit migration |
| Calling backend code directly from a patient or practitioner screen | Add the method to `SessionProvider` and let the screen consume provider state |
| Adding raw `Map<String, dynamic>` handling inside widgets | Extend `Session`, `SessionSummary`, `AssessmentResult`, or `ExerciseResult` instead |
| Assuming `AppRoute` owns navigation | Follow the existing `Navigator.push` pattern unless the task includes a routing refactor |
| Updating only `en.json` when adding text | Keep `en.json` and `ar.json` aligned |
| Treating `features/login/` folder layout as proof of the app’s main architecture | Base decisions on the active screens and provider flow, not placeholder folders |
| Mixing `AppThemes` colors and `HopeColors` without checking nearby code | Match the theme source already used in that area to avoid inconsistent styling |
| Removing debug/logging calls as “cleanup” | Preserve `AppLogger`, `DebugLogStore`, and request logging unless the user asked for their removal |
| Documenting or coding around non-existent assets as if they are real | Verify asset paths from `pubspec.yaml` and the repository tree first |
| Assuming the existing widget test gives full confidence | Treat `test/widget_test.dart` as a minimal smoke test and verify important flows more directly |
