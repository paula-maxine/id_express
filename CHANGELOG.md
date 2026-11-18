# Changelog for the ID Express Flutter app.

## Unreleased

### 2026-11-18

#### Added

- Reviewer documentation suite for technical due diligence: rewritten
  `README.md`, new `FEATURES.md`, `run_instruction.md` and `docs/`
  (`SYSTEM_DEEP_DIVE.md`, `CODEBASE_MAP.md`, `FEATURE_CATALOG.md`,
  `TECHNICAL_HIGHLIGHTS.md`, `ENGINEERING_DECISIONS.md`, `KNOWN_ISSUES.md`,
  `SENSITIVE_MATERIAL_REMOVED.md`, `SUBMISSION_MANIFEST.md`). Written from the
  code; every relative link checked to resolve inside the repository. No
  application code changed.

#### Removed

- Plaintext test-account credentials file `lib/passwords.txt` (unreferenced by
  code; confirmed with grep). Recorded in
  `docs/SENSITIVE_MATERIAL_REMOVED.md` without values. The accounts still need
  rotating by the owner because the file remains in git history.
- AI-assistant files: `.github/copilot-instructions.md`,
  `.github/prompts/plan-niraNationalIdApp.prompt.md`, `docs/rules.md`.
- Thesis reference files `docs/NIRA_Masters_Final_Report_Template.pdf` and
  `docs/NIRA-summary.txt`.
- Machine-generated `macos/Flutter/ephemeral/` (contained local absolute
  paths) and local `.vscode/settings.json`.
- Generated status reports (`COMPLETION_SUMMARY.md`, `PROJECT_COMPLETE.md`,
  `IMPLEMENTATION_PROGRESS.md`, `IMPLEMENTATION_STATUS.md`,
  `IMPLEMENTATION_SUMMARY.md`, `PRE_LAUNCH_CHECKLIST.md`,
  `DOCUMENTATION_INDEX.md`) and stale guides describing a removed prototype
  (`ARCHITECTURE.md`, `COMPLETE_SETUP.md`, `DATABASE_SCHEMA.md`,
  `FILE_STRUCTURE.md`, `GETTING_STARTED.md`, `QUICK_START.md`,
  `SETUP_GUIDE.md`, `SCREEN_IMPLEMENTATION_GUIDE.md`).
- Untracked local caches (`.DS_Store`, `.idea/`, `*.iml`, `.remember/`,
  `.firebase/`, `build/`, `.dart_tool/`).

#### Deploy notes

- Verified with Flutter 3.47.8 / Dart 3.13.7: `flutter pub get` PASS,
  `flutter analyze` PASS (no issues), `flutter build web`, `flutter build apk
  --debug` and `flutter build ios --debug --no-codesign` PASS, `flutter test`
  1 pass / 1 pre-existing failure (`test/model_test.dart`). `pub get`
  rewrote `pubspec.lock` and `analysis_options.yaml`; both were restored to
  their committed content afterwards.
- Owner action: change the passwords of (or delete) the three test accounts
  that were listed in `lib/passwords.txt`.
