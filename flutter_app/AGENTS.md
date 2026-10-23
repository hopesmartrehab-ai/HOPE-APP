# AGENTS.md

This file guides AI coding agents working in the HOPE Flutter repository based on the current project structure and implementation patterns.

## Project Overview

HOPE is a Flutter rehabilitation app for patient session intake, assessment and training activities, video capture/upload, practitioner session review, and patient progress. The app starts in `lib/main.dart`, initializes Hydrated Bloc storage, local storage, Easy Localization, and GetIt registrations, then launches `lib/my_app.dart` and the splash flow. Navigation is a mix of `AppRoute` helpers and direct `Navigator.push`/`MaterialPageRoute` calls. Backend integration is not yet unified: new integrations should use the shared Dio client and feature repositories, while existing features are migrated incrementally against confirmed backend contracts.

The repository is feature-first but mixed in maturity. Active areas include `features/auth`, `features/main_layout`, `features/assessment`, `features/assessment_result`, `features/progress`, `features/rehab`, `features/training`, and older patient/practitioner flows under `features/screens/`. The auth screens currently use demo actions rather than a real authentication backend. Do not assume the codebase is fully migrated to one architecture style.

## Architecture

### Folder Structure

```text
lib/
|-- main.dart                                      # Bootstrap: HydratedBloc, localization, storage, DI
|-- my_app.dart                                    # MaterialApp, theme mode, localization, splash screen
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
|   |   `-- theme/                                 # HopeColors and older screen-level theme helpers used by screens
|   |-- resources/                                 # Bloc observer and debug print helpers
|   |-- services/                                  # Upload and image helpers
|   |-- shared_widgets/                            # Reusable fields, buttons, app bar, dialogs, toasts, image helpers
|   |-- theme/                                     # AppThemes, colors, theme cubit, theme extensions
|   `-- utils/                                     # Route placeholder and enums
|-- features/
|   |-- auth/                                      # Current demo sign-in and registration screens/shared widgets
|   |-- assessment/                                # Assessment entry/setup and assessment-specific flow screens
|   |-- assessment_result/                         # Assessment result entities, repository, Cubit, and screens
|   |-- game/                                      # WebView game, with completion routing based on assessment/practice mode
|   |-- main_layout/                               # Main tab navigation shell
|   |-- models/                                    # Legacy session and exercise models
|   |-- progress/                                  # Progress overview/history/details and typed view models
|   |-- rehab/                                     # Rehabilitation overview and exercise list
|   |-- screens/
|   |   |-- welcome_screen.dart                    # App entry screen after bootstrap
|   |   |-- role_selection_screen.dart              # Patient vs practitioner split
|   |   |-- dashboard/                             # Shared patient/practitioner dashboard UI
|   |   |-- patient/                               # Start session, questionnaire, waiting, results, patient shell
|   |   `-- practitioner/                          # Session list, detail, practitioner shell
|   |-- state/                                     # Shared locale and any retained feature-flow state
|   |-- training/                                  # Shared level flow and practice training results
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
| Bootstrap | `lib/main.dart`, `lib/my_app.dart` | Initialize app-wide services, theme mode, localization, and root widget tree | Hold session business logic or screen-specific state |
| Feature state | `lib/features/<feature>/presentation/logic/` or nearby feature state | Coordinate feature operations, loading/data/error state, and user actions | Own HTTP configuration or render unrelated screens |
| Feature presentation | `lib/features/<feature>/presentation/` | Render screens and reusable widgets from feature state and typed data | Create network clients or parse raw backend payloads |
| Feature data | `lib/features/<feature>/data/` | Remote data sources, repositories, and backend DTO parsing for a feature | Depend on presentation widgets |
| Shared networking | `lib/core/network_services/` | Shared Dio configuration, interceptors, and cross-cutting HTTP behavior | Contain feature endpoint methods or UI state |
| Shared app infrastructure | `lib/core/local_storage/`, `lib/core/di/`, `lib/core/connection/`, `lib/core/resources/` | Storage, DI, connectivity abstraction, logging, bloc observer | Become feature-specific dumping grounds |
| Shared UI system | `lib/core/shared_widgets/`, `lib/core/theme/`, `lib/core/old_core/theme/` | Reusable visual building blocks, app theme data, old Hope color palette helpers | Duplicate one-off feature widgets that belong under `features/` |

### Dependency Direction

| Rule | Meaning |
| --- | --- |
| `feature state -> feature repository` | Cubits, providers, or controllers call feature repositories instead of making HTTP requests |
| `feature repository -> remote data source -> shared client` | Repositories expose feature operations; remote sources own endpoints and DTO mapping; shared clients own transport configuration |
| `feature data -> feature models/entities` | Backend DTOs are converted to typed app models before presentation consumes them |
| `screens -> features/widgets + core/shared_widgets` | Compose screens from shared widgets before creating new UI primitives |
| `my_app.dart -> ThemeCubit` | Theme mode is Bloc-driven at the app shell level |
| `main_layout -> tab features` | The main navigation shell hosts Home, Rehab, Progress, and Profile in an `IndexedStack`; locale-keyed subtrees rebuild tab content when language changes |
| `assessment -> training` | Assessment-specific intro runs before the shared `TrainingFlowScreen`; its completion callback continues to assessment analysis/report |
| `game -> result destination` | `AssessmentGameWebView` receives `isAssessmentMode`; assessment games open the assessment report, while practice games open completion-only training results |
| `screens -X-> network clients` | UI screens must not call Dio/http clients or parse raw API responses directly |
| `features/auth -X-> real authentication` | Current Sign In and Sign Up buttons are demo navigation actions; do not represent them as backend authentication |
| `feature -> core` | Features may reuse localization, helpers, storage, theme, shared widgets, and services from `core` |

### Architecture Patterns

| Pattern | Current implementation |
| --- | --- |
| Feature-first organization | Product work is organized under `lib/features/` |
| Feature state ownership | Existing features use Provider, Cubit/Bloc, and local widget state; follow the pattern already established within each feature |
| Mixed state management | `provider` drives session flows, while `flutter_bloc` and `hydrated_bloc` are primarily used for app-level theme persistence |
| Navigator-based routing | Screens use both direct `Navigator.push`/`MaterialPageRoute` and `AppRoute` helpers |
| Typed API parsing | Backend DTOs and app models belong in feature data/domain layers, not in screens |
| Shared backend infrastructure | `core/network_services` supplies the shared Dio client; feature repositories own backend operations |
| Shared assessment/training UI | `features/training` owns the reusable level-by-level experience; Assessment wraps it with an assessment intro and its own analysis/report flow |
| Mode-specific game completion | Assessment game completion loads the backend assessment report; Practice game completion shows training completion without claiming a measured score |
| Localization via constants | User-facing text is expected to go through `LocaleKeys.<key>.tr()` with translation JSON files in `assets/translations/` |
| Shared widget reuse | Buttons, form fields, dialogs, toasts, and media widgets are centralized in `core/shared_widgets/` and `features/widgets/` |
| Debug tooling | Debug utilities may exist in older code, but verify current call sites before assuming an overlay or request logger is active |

### Current Architecture Notes

| Area | Current state |
| --- | --- |
| App entry | `main.dart` initializes Easy Localization for `en` and `ar`, HydratedBloc storage, local storage, and GetIt before running `MyApp` |
| Root app shell | `my_app.dart` wraps the app in `MultiBlocProvider`, uses `ThemeCubit`, and starts at `SplashScreen`; the welcome/auth flow can route to `MainNavigationScreen` |
| Main navigation | `MainNavigationScreen` hosts Home, Rehab, Progress, and Profile tabs in an `IndexedStack`; locale-keyed tab subtrees refresh translated content after a language switch |
| Routing | Most flows use direct `Navigator.push`/`MaterialPageRoute`, with `AppRoute` used for common destinations |
| Session flow | The current assessment/training setup is screen-flow driven; inspect existing feature state before extending it |
| Backend configuration | `lib/config.dart` and `lib/core/network_services/web_constant.dart` define different backend hosts; confirm service ownership before choosing a host or consolidating them |
| Shared API client | `lib/core/network_services/api_service.dart` creates a Dio client with timeouts, language headers, token interceptor, and request/response logging |
| Existing backend integration | `features/assessment_result/data/repositories/assessment_result_repository.dart` uses the shared Dio service and typed parsing; many other feature surfaces remain demo- or sample-data-backed |
| Backend readiness gaps | Auth screens are demo-only; the token interceptor currently sends a masked literal rather than the stored token, and a prototype assessment key is embedded in the app. Do not treat this setup as production-ready |
| Auth flow | `lib/features/auth/login/screens/sign_in_screen.dart` and `lib/features/auth/register/sign_up_screen.dart` currently provide demo forms; their primary actions route directly to `MainNavigationScreen` and do not authenticate against a backend |
| Assessment results | `lib/features/assessment_result/` loads typed latest-session results through `AssessmentResultRepository` and `AssessmentResultCubit`; keep this clinical assessment report separate from practice completion results |
| Progress feature | `lib/features/progress/` contains typed models and reusable widgets for overview, session history/details, assessment history/comparison, and detailed progress; current screens use sample data pending API integration |
| Shared training feature | `lib/features/training/` owns the shared level flow and training result screen. `TrainingResultModel` currently represents completion counts/derived completion grade, not backend-measured performance; do not treat it as an assessment score |
| Smart Glove setup | The Smart Glove option is selectable. The current `ConnectGloveView` simulates connection after three seconds; it does not perform real Bluetooth/device discovery. Smart Glove format selection exposes Video only, while non-glove training can select Video or Game |
| Game completion | `AssessmentGameWebView.isAssessmentMode` selects the destination after the game's completion console signal: assessment opens `AssessmentReportPage`; practice opens the completion-only `TrainingResultsScreen.game()` |
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
| Networking | Dio is the shared configured HTTP client; `http` remains a declared dependency, but no active legacy API service is present in this checkout |
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

Use the existing feature organization as the main reference. Backend integrations should follow the target repository/data-source/shared-client boundary described below.

```text
features/
|-- models/                      # Backend-facing typed models
|-- screens/
|   |-- <feature_area>/          # Route-level screens grouped by role or area
|   `-- <screen>.dart
|-- state/                       # ChangeNotifier providers and app flow state
`-- widgets/                     # Reusable widgets tied to active HOPE flows
```

When extending a feature, first inspect the files actually present in the checked-out branch. Keep small UI-only changes local. For backend work, use the shared client and add the smallest appropriate remote data source/repository and feature state integration; introduce domain entities only when the feature benefits from that separation.

### Backend Integration Workflow

For each endpoint, confirm the contract and owning service, add a typed feature DTO and remote data source, implement the repository operation/error mapping, expose it through the feature's established state pattern, connect the UI, update both translations if copy changes, and test parser/repository/state behavior without a live network. Do not add guessed endpoints or bypass the repository boundary.

### File, Directory, and Dart Naming

| Type | Convention | Example |
| --- | --- | --- |
| Directories/files | `snake_case` | `session_list_screen.dart`, `session_provider.dart` |
| Class names | `PascalCase` | `AssessmentResultCubit`, `PractitionerShellScreen` |
| Methods/variables | `lowerCamelCase` | `startPollingForExercise`, `_pollCount` |
| Screen files | `<name>_screen.dart` | `questionnaire_screen.dart` |
| Shell/root screen files | `<role>_shell_screen.dart` | `patient_shell_screen.dart` |
| Provider/state files | `<feature>_provider.dart` or `<feature>_cubit.dart` | `locale_provider.dart`, `theme_cubit.dart` |
| Model files | Singular concept names in `snake_case` | `session.dart`, `assessment_result.dart`, `exercise_result.dart` |
| Shared widget files | Name by UI responsibility | `custom_button.dart`, `result_card.dart`, `language_toggle.dart` |
| Constants files | Shared noun-based names | `locale_keys.dart`, `api_keys.dart`, `assets_constants.dart` |

### Flutter Style Values

Write UI numeric values directly. Do not use inline arithmetic expressions for styling values such as `height`, `width`, `fontSize`, `padding`, `radius`, animation angles, or text line-height. For example, write `height: 1.25` instead of `height: 37.5 / 30`.

Use `SingleChildScrollView` for scrollable Flutter screen content. Do not use `LayoutBuilder` for these responsive screen layouts.

### API, Model, Localization, and Error Rules

#### Target backend architecture for all features

Use the same feature-to-backend boundary for every new API integration:

```text
Screen / widget
  -> feature state (Cubit, Provider, or controller)
    -> feature repository
      -> feature remote data source
        -> shared Dio client from GetIt
          -> configured backend service
```

This is the target architecture, not a statement that all features are already connected to APIs. Keep feature code in the owning feature and shared transport in `core`:

```text
lib/
|-- core/
|   |-- network_services/
|   |   |-- api_service.dart         # Shared Dio client and common interceptors
|   |   |-- backend_config.dart     # Target: environment and service base URLs
|   |   `-- api_exception.dart      # Target: normalized transport/API failures
|   `-- di/service_locator.dart     # Register shared clients/services
`-- features/<feature>/data/
    |-- data_sources/<feature>_remote_data_source.dart
    |-- models/<feature>_dto.dart   # JSON parsing/serialization
    `-- repositories/<feature>_repository.dart
```

The target filenames above are illustrative: follow a feature's existing organization and add only files needed for its real backend contract.

**Shared transport and configuration**

- Use the registered Dio client from `core/di/service_locator.dart`; do not construct clients in screens or create one per feature.
- Centralize environment-specific URLs and service identity. This checkout defines multiple hosts in `lib/config.dart` and `lib/core/network_services/web_constant.dart`; keep separate named service configurations if the backend contracts are separate. Do not silently merge or replace hosts.
- Keep endpoint paths in feature remote data sources, not screens, models, or the shared `ApiService`.
- Configure timeouts, JSON headers, and the app language header according to each backend contract.
- Interceptors may attach a real user access token and log sanitized request metadata. Never log credentials, prototype keys, private health data, or sensitive request/response bodies.
- Never embed private API keys or shared secrets in mobile source/assets. App constants are extractable; use user authentication or a server-side proxy, and use build-time configuration only for non-secret values.

**Feature data, domain, and presentation**

- A remote data source performs a narrow endpoint operation and parses the wire response into a typed DTO.
- DTOs own JSON parsing/serialization and validation. Map DTOs into app/domain models in the repository when that feature uses a separate domain layer.
- Repositories expose feature-level operations and convert transport, HTTP, and parsing errors into explicit typed errors. Do not hide failures behind empty lists, zero scores, or success-shaped fallback objects.
- Cubit/Bloc, Provider, or a feature controller calls the repository and exposes loading, success, empty, and failure states. Continue using the state pattern already established within that feature.
- Widgets render typed state and dispatch actions; they do not create URLs, attach headers, invoke clients, or inspect raw JSON.
- Keep auth/session, assessment, practice/training, progress, game, media upload, and practitioner records in feature-specific repositories even when they share the same client.
- Assessment outcomes and performance scores must reflect actual backend/device results. Do not infer clinical performance from completion or hard-code sample values as real results.

**Contracts, errors, and reliability**

- Confirm endpoint path, method, authentication, request/response JSON, units, nullability, pagination, and error schema before implementing an integration. Do not guess missing fields or endpoints.
- Validate required response fields and handle optional/malformed data explicitly. Preserve safe diagnostic context such as status code/request ID, but never expose raw server details to users.
- Distinguish connectivity, timeout, cancellation, unauthorized, forbidden, not-found, validation, server, and malformed-response failures. Translate these into localized, actionable feature state.
- Retry idempotent reads only by default. Mutations and uploads need an explicit idempotency/retry policy to avoid duplicate sessions or submissions.
- Define user scoping and freshness for records. A global “latest” endpoint is not an authenticated user's record unless the backend contract guarantees that ownership.
- Cache only with a documented freshness and ownership policy. Mark cached/stale results and give users a deliberate retry path.
- Media uploads should request a short-lived upload target from the backend, upload through the appropriate service, and report completion through feature state. Never ship permanent upload credentials.

**Migration plan for this codebase**

1. Use `core/network_services/api_service.dart` and `AssessmentResultRepository` as the current Dio-backed starting point, but fix the token-header and sensitive logging gaps before relying on authenticated production traffic.
2. Migrate endpoint-by-endpoint into feature remote data sources and repositories; preserve existing behavior and verify parity before removing any legacy implementation.
3. Keep currently configured hosts operational until backend owners confirm whether they are replacements or distinct services.
4. Connect demo auth, progress sample data, training/game results, and simulated glove status only when their actual backend/device contracts are available.
5. Test DTO parsing, repository request/error mapping, and feature-state transitions independently using injected fakes or a Dio mock adapter; tests must not require live network access.

| Rule | Required behavior |
| --- | --- |
| API path | For new integrations, use a feature repository and remote data source over the shared Dio client; inspect actual legacy implementations before extending or removing them |
| Base URL usage | Resolve a configured service base URL; never hard-code endpoint roots in screens or repositories |
| Models first | Parse backend payloads into typed DTOs/domain models before presentation consumes them |
| Error types | Map transport, HTTP, and parse failures into explicit typed errors and feature state without success-shaped fallbacks |
| State ownership | Feature Cubit/Provider/controller calls repositories; screens do not call networking directly |
| User-facing text | Use `LocaleKeys.<key>.tr()` for visible strings |
| Locale parity | When adding a translation key, update `assets/translations/en.json` and `assets/translations/ar.json` together |
| Existing locale scope | Do not document or implement extra active locales unless the app is actually configured for them |
| Backend messages | If the backend returns meaningful text through existing flow plumbing, prefer showing it instead of inventing generic replacements |
| JSON keys | Reuse constants where they already exist, but do not force `ApiKeys` into places where the current codebase is already using typed direct field parsing |
| Screen errors | Keep transient UI feedback in snackbars, toasts, dialogs, or existing shared feedback widgets, not inside low-level service classes |

### Feature and Module Responsibilities

| Area | Responsibility |
| --- | --- |
| `features/state/` | Shared state that has not yet moved into feature-scoped presentation logic; inspect current files before extending |
| `features/screens/patient/` | Patient-first flow from session start through assessment, questionnaire, exercise wait, and results |
| `features/screens/practitioner/` | Practitioner session list, detail view, delete flow, and practitioner dashboard shell |
| `features/screens/dashboard/` | Shared role-based dashboard visualization |
| `features/widgets/` | Reusable active-flow widgets for scores, videos, errors, and result cards |
| `features/assessment/` | Assessment-specific entry/setup and the assessment wrapper around shared training |
| `features/assessment_result/` | Backend assessment-result repository, typed outcomes, Cubit, and report/detail screens |
| `features/training/` | Shared level-by-level training flow plus practice completion results |
| `features/progress/` | Progress overview, history, comparison, and details; currently sample-data-backed |
| `features/game/` | WebView game; completion destination is selected by assessment/practice mode |
| `features/main_layout/` | Home, Rehab, Progress, and Profile tab navigation |
| `features/auth/` | Demo sign-in/registration screens; primary actions currently route to the main tab layout |
| `core/shared_widgets/` | App-wide building blocks that are not specific to one session screen |
| `core/old_core/debug/` | Request logging, state transition tracing, and in-app debug overlay support |
| `core/theme/` | App-level light/dark theme definition and persistence |
| `core/old_core/theme/` | Legacy Hope palette helpers still imported by many active screens |
| `features/login/` | Transitional scaffold only; current demo sign-in and registration screens live under `features/auth/` |

## Do

| Do | Why |
| --- | --- |
| Inspect the relevant feature and current checkout before coding | The repository contains active features alongside older and transitional areas |
| Keep backend state changes behind that feature's repository | Screens should consume typed feature state rather than call HTTP |
| Parse backend payloads into typed DTOs/models before presentation consumes them | Typed parsing keeps screens cleaner |
| Reuse `core/shared_widgets/` and `features/widgets/` before making new primitives | The project already centralizes common controls and display cards |
| Keep navigation consistent with nearby screens | Most active flows use direct `Navigator.push` and `MaterialPageRoute` |
| Use `LocaleKeys` and update both translation files together | The active app is localized in English and Arabic |
| Respect the split between `core/theme/` and `core/old_core/theme/` | Many screens still rely on `HopeColors` even though the app shell uses `AppThemes` |
| Preserve existing logging hooks when touching providers and services | Keep any logging already wired into the specific flow; do not assume optional legacy debug utilities are enabled globally |
| Run formatting and focused analysis after edits | The project has several transitional layers and warning drift is easy |
| Call out incomplete migrations when they matter to the task | Agents should not silently normalize the repo into an architecture it does not yet have |

## Don't

| Don't | Why |
| --- | --- |
| Do not add new backend calls directly to screens or shared transport | Put endpoint operations in feature remote data sources and repositories over the shared Dio client |
| Do not assume a legacy service or provider exists based on old documentation | Inspect the checked-out files and migrate incrementally against real contracts |
| Do not invent a full clean-architecture slice for a small UI or provider change | The surrounding active code does not use that structure |
| Do not treat `features/auth/` as a finished production auth module | The current forms route to the app without authenticating against a backend |
| Do not hard-code user-facing strings in screens | Use localization keys and translation JSON |
| Do not add extra locales, Firebase, CI, or backend tooling in documentation unless they are actually present | This repository should be described as it exists now |
| Do not remove old theme or debug utilities casually | Active screens still depend on them |
| Do not assume every route goes through `AppRoute` | Active flows use both `AppRoute` helpers and direct `Navigator` calls |
| Do not move shared UI into `core/` unless it is reused broadly | Session-specific widgets should stay under `features/widgets/` |
| Do not ignore asset-path reality | If an asset directory is missing, fix the reference or asset setup instead of documenting imaginary files |

## Common Mistakes

| Mistake | Correct approach |
| --- | --- |
| Adding feature endpoint methods to the shared Dio client | Keep endpoint paths and operations in a feature remote data source/repository |
| Calling backend code directly from a screen | Add a repository operation and expose it through the feature's established state layer |
| Adding raw `Map<String, dynamic>` handling inside widgets | Parse wire JSON in typed DTOs before presentation consumes it |
| Assuming `AppRoute` owns navigation | Follow the existing `Navigator.push` pattern unless the task includes a routing refactor |
| Updating only `en.json` when adding text | Keep `en.json` and `ar.json` aligned |
| Treating `features/login/` folder layout as proof of the app’s main architecture | The current visible auth screens are under `features/auth/`; their forms are demo-only and do not authenticate |
| Mixing `AppThemes` colors and `HopeColors` without checking nearby code | Match the theme source already used in that area to avoid inconsistent styling |
| Removing debug/logging calls as “cleanup” | Preserve `AppLogger`, `DebugLogStore`, and request logging unless the user asked for their removal |
| Documenting or coding around non-existent assets as if they are real | Verify asset paths from `pubspec.yaml` and the repository tree first |
| Assuming the existing widget test gives full confidence | Treat `test/widget_test.dart` as a minimal smoke test and verify important flows more directly |
