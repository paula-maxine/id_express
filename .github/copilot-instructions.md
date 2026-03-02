# Copilot instructions for id_express

This file contains concise, repo-specific guidance to help AI coding agents be productive immediately.

1) Big picture
- This is a Flutter app (multi-platform) with Firebase back-end integration. See [pubspec.yaml](pubspec.yaml#L1-L40) for main deps.
- App entry: [lib/main.dart](lib/main.dart#L1-L40) — initializes Firebase using [lib/firebase_options.dart](lib/firebase_options.dart#L1-L200) and starts `IdExpress` at [lib/app/id_express.dart](lib/app/id_express.dart#L1).
- Key layers: UI (`lib/app`, `lib/screens`), routing (`lib/routes`), state/providers (`lib/providers`), domain/data (`lib/data`, `lib/services`), global config (`lib/global`). Follow these locations when making cross-cutting changes.

2) Architecture & patterns to follow
- State management: Riverpod + codegen. Look for `riverpod_annotation` usages and generated providers. Run codegen rather than hand-editing generated files.
- Routing: `go_router` is used; routing live in `lib/routes` (match route names and handlers there).
- Firebase: Auth, Firestore, Storage, Messaging. Initialization and platform options are centralized in [lib/firebase_options.dart](lib/firebase_options.dart#L1-L200).

3) Build / dev workflows (commands)
- Install deps: `flutter pub get`.
- Run app: `flutter run -d <device>` or use IDE run targets.
- Generate code (required after changing annotated classes/providers/models):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- Tests: unit/widget tests with `flutter test`. Integration tests live under `integration_test` and use the Flutter integration test runner.

4) Files & conventions (examples)
- Generated code: files created by `build_runner` live next to annotated source. Do not edit generated files — change the source and re-run `build_runner`.
- Firebase config: platform keys are in [lib/firebase_options.dart](lib/firebase_options.dart#L1-L200); native configs are under `android/` and `ios/` (e.g., `android/app/google-services.json`).
- Main app shell: [lib/app/id_express.dart](lib/app/id_express.dart#L1) is the place for themes, top-level providers, and router setup.

5) Tests, linters, and code style
- Lints: `flutter_lints` and `riverpod_lint` are enabled. Run `flutter analyze` and fix lints before PRs.
- Mocks: `mocktail` is used for unit tests; follow existing test patterns under `test/` when adding new tests.

6) Integrations & external dependencies
- Firebase services are central — changing Firestore/Storage usage or rules may require coordination with project owners.
- Native platform changes (plugin upgrades, Gradle, Podfile edits) require platform rebuilds and inspecting `android/` and `ios/` folders.

7) Typical PR tasks for AI agents
- Feature work: update `lib/`, run `build_runner`, run `flutter analyze`, run `flutter test` locally.
- Bug fixes: search for provider usage in `lib/providers` and traces in `lib/screens`/`lib/app`.

8) Quick checks before editing
- Confirm required packages in [pubspec.yaml](pubspec.yaml#L1-L60).
- Re-run codegen after changing providers/models.
- Do not change Firebase keys in `lib/firebase_options.dart` without owner approval.

If you'd like, I can expand this with exact provider name patterns, common generated filename suffixes, or references to a few representative providers/screens.
