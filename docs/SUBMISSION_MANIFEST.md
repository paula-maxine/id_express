# Submission Manifest

[Back to README](../README.md)

## Project

- **Name:** ID Express (`id_express`, version `1.1.0+2` in `pubspec.yaml`)
- **Description:** Flutter + Firebase application for applying for, reviewing
  and scheduling national ID services, modelled on Uganda's NIRA process.
- **Primary purpose:** move the ID application, review and appointment
  workflow online with role-based access.
- **Target users:** citizens (applicants), registration officers and
  supervisors, administrators.
- **Development period:** git history spans 2026-02-12 to 2026-07-08
  (17 commits).

## Technology

- **Languages:** Dart; Kotlin, Swift and C++ only in the Flutter platform
  runners; Firebase security-rules language.
- **Frameworks:** Flutter (Dart `^3.10.4`), Riverpod 3 with code generation,
  go_router 17.
- **Platforms:** Android, iOS and web configured for Firebase; macOS, Windows
  and Linux runners present (macOS and Linux Firebase options unconfigured).

## Components

- Flutter client (`lib/`)
- Firestore security rules and composite indexes
- Storage security rules
- Firebase Hosting configuration and cache-busting web loader
- Release scripts (`scripts/`)

## Capabilities

Registration and sign-in; role-based routing; four-step ID application for
four service types; live application tracking; document upload to Cloud
Storage; appointment booking with queue numbers and overdue handling; staff
review with approve, reject and biometrics capture; admin role management;
append-only audit trail; push opt-in and in-app notification list. Full list:
[FEATURE_CATALOG.md](FEATURE_CATALOG.md).

## Architecture

Client-only: the Flutter app reads Firestore through real-time streams and
writes directly; `firestore.rules` and `storage.rules` enforce authorization.
See [SYSTEM_DEEP_DIVE.md](SYSTEM_DEEP_DIVE.md).

## Integrations

Firebase Authentication, Cloud Firestore, Cloud Storage, Cloud Messaging,
Firebase Hosting, Google Fonts, AppSend (test-build distribution).

## Engineering Characteristics

- Role-derived authorization in rules, with role immutability for non-admins,
  parent-derived ownership for documents and an append-only audit collection
- Router guards that react to live role changes
- Registration rollback on partial failure
- Derived appointment status with batched persistence
- Composite indexes declared for every compound query
- Offline persistence enabled

## Sanitization

AI-assistant instruction files, generated status reports, stale guides,
private academic documents, a plaintext test-credentials file and
machine-specific generated files were removed. Firebase client configuration
was kept and documented for regeneration. Full register:
[SENSITIVE_MATERIAL_REMOVED.md](SENSITIVE_MATERIAL_REMOVED.md).

## Repository Statistics

Counted on 2026-11-18 from tracked files after clean-up.

| Measure | Value |
| --- | --- |
| Hand-written Dart files (`lib/`, `test/`, `scripts/`, excluding `*.g.dart` and `lib/firebase_options.dart`) | 188 |
| of which in `lib/` | 184 (13,308 lines) |
| Generated `*.g.dart` files | 23 |
| Platform-runner source files (`.kt`, `.swift`, `.cc`, `.cpp`, `.h`, excluding generated plugin registrants) | 19 |
| Feature folders | 10 (plus shared `features/models/`) |
| Routes | 18 |
| Composite Firestore indexes | 9 |
| Tests | 2 (1 passing, 1 failing) |
