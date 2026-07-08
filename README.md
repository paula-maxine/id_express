# ID Express

**ID Express** is a cross-platform National ID application and management system built with
**Flutter** and **Firebase**. It is modelled on a NIRA-style national identity workflow
(Uganda's National Identification and Registration Authority), letting citizens apply for and
track a National ID online, while officers and administrators review applications, manage
appointments, and oversee the whole process from a single app.

The same codebase runs on **Android, iOS, Web, macOS, Windows, and Linux**.

---

## Table of Contents

- [What the app does](#what-the-app-does)
- [User roles](#user-roles)
- [Core workflows](#core-workflows)
- [Tech stack](#tech-stack)
- [Architecture](#architecture)
- [Project structure — where everything lives](#project-structure--where-everything-lives)
- [Feature-by-feature map](#feature-by-feature-map)
- [Data model & Firestore collections](#data-model--firestore-collections)
- [Routing](#routing)
- [Getting started](#getting-started)
- [Common commands](#common-commands)
- [Building & shipping test builds](#building--shipping-test-builds)
- [Security model](#security-model)
- [Further documentation](#further-documentation)

---

## What the app does

At a high level, ID Express digitises the National ID lifecycle:

1. A **citizen (applicant)** signs up, fills in a multi-step application form, uploads the
   required documents (birth certificate, passport photo, etc.), and books an in-person
   appointment at a service centre.
2. An **officer / supervisor** reviews submitted applications, approves or rejects them with a
   reason, and manages the daily appointment queue.
3. An **admin** manages users and roles across the system.
4. Everyone gets **push + in-app notifications** as an application moves through its stages, and
   every sensitive action is written to an **audit log**.

Applications move through a clear status pipeline:

```
draft → submitted → underReview → approved → biometricPending → cardReady
                                 ↘ rejected
```

---

## User roles

Roles are defined in `lib/data/model/enums/user_role.dart` and drive both routing and Firestore
security rules.

| Role         | Can do                                                                        |
|--------------|-------------------------------------------------------------------------------|
| `applicant`  | Register, submit/track applications, upload documents, book appointments      |
| `officer`    | Review applications, approve/reject, manage daily appointments                |
| `supervisor` | Everything an officer can do (elevated staff role)                            |
| `admin`      | Everything above + manage users and assign roles                              |

The router (`lib/routes/router.dart`) redirects users based on role: applicants land on the
applicant home; officers/supervisors/admins land on the officer home. Staff-only and
applicant-only routes are enforced with redirects.

---

## Core workflows

### Applicant journey
`Welcome → Register / Login → Applicant Home → New Application (multi-step form) →
Upload Documents → Book Appointment → Track status → Notifications`

### Officer journey
`Login → Officer Home (stats + queue) → Review Application (documents + details) →
Approve / Reject (with reason) → Manage daily appointments`

### Admin journey
`Login → Officer Home → Manage Users (view users, assign/change roles)`

---

## Tech stack

| Concern            | Choice                                                        |
|--------------------|--------------------------------------------------------------|
| Framework          | Flutter (Dart SDK `^3.10.4`)                                  |
| State management   | **Riverpod** (`flutter_riverpod` + `riverpod_generator`)     |
| Navigation         | **go_router** (declarative, code-generated routes)           |
| Backend            | **Firebase** — Auth, Cloud Firestore, Storage, Messaging     |
| Serialization      | `json_serializable` / `json_annotation` (`*.g.dart` files)   |
| Local persistence  | `sembast` + `path_provider` (offline sync cache)             |
| Auth / security    | `local_auth` (biometrics), `flutter_secure_storage`          |
| Media / files      | `image_picker`, `file_picker`, `cached_network_image`        |
| UI                 | Material Design, `google_fonts`, `flutter_svg`               |
| Connectivity       | `connectivity_plus`                                          |

See `pubspec.yaml` for the full, versioned dependency list.

---

## Architecture

ID Express follows **Feature-Driven Development (FDD)** with an **MVVM** pattern per feature.

Each feature under `lib/features/<feature>/` is self-contained and typically has:

```
features/<feature>/
├── model/          # Feature-specific value objects (not the shared Firestore models)
├── view/           # Widgets & screens (the "V" in MVVM)
├── view_model/     # Riverpod providers holding state & logic (the "VM")
├── service/        # Feature service — talks to the data/cloud layer
└── exporter.dart   # Barrel file re-exporting the feature's public API
```

The layers, from UI down to the backend:

```
┌───────────────────────────────────────────────────────────┐
│  View (Flutter widgets/screens)                            │  lib/features/*/view
├───────────────────────────────────────────────────────────┤
│  ViewModel (Riverpod providers)                            │  lib/features/*/view_model
├───────────────────────────────────────────────────────────┤
│  Feature Service (per-feature orchestration)               │  lib/features/*/service
├───────────────────────────────────────────────────────────┤
│  Cloud Services (Firestore/Storage/Auth wrappers)          │  lib/data/cloud
├───────────────────────────────────────────────────────────┤
│  Models + Repositories + Local sync                        │  lib/data/model, lib/data/repository, lib/data/local
├───────────────────────────────────────────────────────────┤
│  Firebase (Auth · Firestore · Storage · Messaging)         │  cloud
└───────────────────────────────────────────────────────────┘
```

> **Note on `.g.dart` files:** files ending in `.g.dart` are **generated** by `build_runner`
> (Riverpod providers and JSON serialization). Never edit them by hand — regenerate with
> `dart run build_runner build`.

> **Barrel files (`exporter.dart`):** almost every folder has an `exporter.dart` that re-exports
> its contents, so imports elsewhere stay short (e.g. `import '../app_exporter.dart';`).

---

## Project structure — where everything lives

Top-level layout of the repository:

```
id_express/
├── lib/                  # All Dart source (see below)
├── android/ ios/ web/    # Platform runners (also macos/ windows/ linux/)
├── macos/ windows/ linux/
├── test/                 # Unit & widget tests
├── scripts/              # Versioning & test-build deploy scripts (Dart)
├── docs/                 # NIRA reference material & extra docs
├── firebase.json         # Firebase project config (Firestore, Hosting, platforms)
├── firestore.rules       # Firestore security rules
├── firestore.indexes.json# Composite index definitions
├── storage.rules         # Cloud Storage security rules
├── pubspec.yaml          # Dependencies & Flutter config
└── *.md                  # Additional design/status docs (see below)
```

### Inside `lib/`

```
lib/
├── main.dart                 # Entry point: Firebase init, error handling, runApp
├── firebase_options.dart     # Generated Firebase config (per platform)
│
├── app/
│   └── id_express.dart       # Root MaterialApp.router widget
│
├── core/                     # Cross-cutting building blocks
│   ├── constants/            # Spacing, dimens, padding, durations, strings, radii
│   ├── extensions/           # Handy extensions on String, num, DateTime, Color
│   ├── functions/            # Shared helper functions
│   ├── printer/              # Structured console logger (Printer)
│   ├── responsive/           # Responsive layout helpers
│   ├── theme/                # Colors, text styles, ThemeData
│   └── widgets/              # Reusable UI (AppButton, EmptyState, loaders, …)
│
├── data/                     # Data layer
│   ├── cloud/                # Firestore/Storage/Auth service wrappers + AppException
│   ├── local/                # sync_service.dart (offline caching via sembast)
│   ├── model/                # Shared domain models (+ generated .g.dart)
│   │   └── enums/            # UserRole, ApplicationStatus, DocumentType, Gender, …
│   ├── repository/           # Application & Document repositories
│   └── mock/                 # Mock data for development/testing
│
├── features/                 # Feature modules (MVVM, see Architecture)
│   ├── auth/                 # Welcome, login, register
│   ├── applicant_home/       # Applicant dashboard: services, quick stats
│   ├── application_form/     # Multi-step application wizard
│   ├── applications/         # Application list & detail
│   ├── documents/            # Document upload & management
│   ├── appointments/         # Book & view appointments
│   ├── notifications/        # In-app notification centre
│   ├── officer/              # Officer home, review screens, stats
│   ├── admin/                # User & role management
│   ├── profile/              # User profile
│   └── models/               # Feature-side model/enum definitions
│
├── routes/                   # go_router setup, paths, error page (router.g.dart generated)
├── providers/                # App-wide Riverpod providers (auth, router, services, etc.)
├── global/                   # Alternate shared theme/widgets/constants set
├── services/                 # Legacy top-level services (auth, firestore, storage)
├── screens/                  # Legacy screen set (pre-feature-refactor)
└── utils/                    # Utilities (e.g. tracking_utils.dart)
```

> **Heads-up on `screens/`, `services/`, `providers/`, `global/`:** the project has been
> migrated toward the `features/` + `data/` structure. Some older `screens/`, top-level
> `services/`, and `global/` files remain from the earlier architecture. When adding new
> functionality, **prefer the `features/` + `data/cloud/` pattern**; treat `screens/` and
> top-level `services/` as legacy.

---

## Feature-by-feature map

Use this table to jump straight to the code for a given capability.

| Feature / capability          | Where it lives                                                    |
|-------------------------------|-------------------------------------------------------------------|
| App entry / Firebase init     | `lib/main.dart`                                                   |
| Root app widget & theme       | `lib/app/id_express.dart`                                         |
| Welcome / Login / Register    | `lib/features/auth/`                                              |
| Applicant dashboard           | `lib/features/applicant_home/`                                    |
| Start / fill an application   | `lib/features/application_form/` (steps: personal, address, family, review) |
| Applications list & detail    | `lib/features/applications/`                                      |
| Upload / manage documents     | `lib/features/documents/`                                         |
| Appointments (book & view)    | `lib/features/appointments/`                                      |
| Notifications                 | `lib/features/notifications/`                                     |
| Officer review & approval     | `lib/features/officer/` (review screen, reject dialog, action bar)|
| Admin — manage users/roles    | `lib/features/admin/`                                             |
| User profile                  | `lib/features/profile/`                                           |
| Firestore/Storage/Auth access | `lib/data/cloud/*_cloud_service.dart`                             |
| Shared models & enums         | `lib/data/model/` and `lib/data/model/enums/`                     |
| Offline sync cache            | `lib/data/local/sync_service.dart`                               |
| Routing & guards              | `lib/routes/router.dart`, `lib/routes/paths.dart`                |
| Theme / colors / typography   | `lib/core/theme/`                                                 |
| Reusable widgets              | `lib/core/widgets/`, `lib/global/widgets/`                        |

### Application-form steps
The multi-step wizard lives in `lib/features/application_form/view/`:
`personal_info_step.dart` → `address_info_step.dart` → `family_info_step.dart` →
`review_step.dart`, coordinated by `application_form_screen.dart` with a `step_indicator.dart`.

### Officer review
`lib/features/officer/view/officer_review_screen.dart` renders the application, its documents and
details (`review_detail_section.dart`, `review_section_card.dart`), with an action bar
(`review_action_bar.dart`) and a rejection dialog (`reject_reason_dialog.dart`).

---

## Data model & Firestore collections

The app reads/writes the following Firestore collections (see `lib/data/cloud/`):

| Collection        | Purpose                                        | Cloud service                          |
|-------------------|------------------------------------------------|----------------------------------------|
| `users`           | User profiles & roles                          | `user_cloud_service.dart`              |
| `applications`    | ID applications and their status               | `application_cloud_service.dart`       |
| `documents`       | Uploaded document metadata                     | `document_cloud_service.dart`          |
| `appointments`    | Service-centre appointments                    | `appointment_cloud_service.dart`       |
| `service_centres` | Physical service-centre records                | `service_centre_cloud_service.dart`    |
| `audit_logs`      | Immutable log of sensitive actions             | `audit_cloud_service.dart`             |

**Key enums** (`lib/data/model/enums/` and `lib/features/models/enums.dart`):

- `UserRole` — `applicant`, `officer`, `supervisor`, `admin`
- `ApplicationType` — `newRegistration`, `renewal`, `replacement`, `changeOfParticulars`
- `ApplicationStatus` — `draft`, `submitted`, `underReview`, `approved`, `biometricPending`, `cardReady`, `rejected`
- `DocumentType` — `birthCertificate`, `passportPhoto`, `supportingDocument`, `nationalId`
- Plus `Gender`, `MaritalStatus`, `NotificationType`

Composite indexes required by the app's queries are declared in `firestore.indexes.json`.

---

## Routing

All route paths are constants in `lib/routes/paths.dart`; the router and guards live in
`lib/routes/router.dart` (`goRouterProvider`). A quick reference:

| Path                     | Screen                    | Access        |
|--------------------------|---------------------------|---------------|
| `/welcome`               | Welcome                   | public        |
| `/login`, `/register`    | Auth                      | public        |
| `/applicant-home`        | Applicant dashboard       | applicant     |
| `/application/new`       | New application form      | applicant     |
| `/applications`          | Applications list         | applicant     |
| `/application/:id`       | Application detail        | applicant     |
| `/documents`             | Documents                 | applicant     |
| `/appointments`          | Appointments              | applicant     |
| `/book-appointment`      | Book appointment          | applicant     |
| `/notifications`         | Notifications             | all           |
| `/profile`               | Profile                   | all           |
| `/officer-home`          | Officer dashboard         | staff         |
| `/officer/review/:id`    | Officer review            | staff         |
| `/admin/manage-users`    | Manage users              | admin/staff   |

Unauthenticated users are redirected to `/welcome`; logged-in users are sent to the home screen
that matches their role.

---

## Getting started

### Prerequisites

- **Flutter SDK** with Dart `^3.10.4` (`flutter --version` to check)
- A configured **Firebase project** (`google-services.json` for Android,
  `GoogleService-Info.plist` for iOS, and `lib/firebase_options.dart`)
- Platform toolchains for whatever target you're building (Android Studio / Xcode / etc.)

### Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (Riverpod providers + JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

> Firebase is already wired up via `lib/firebase_options.dart` (project `id-express-paula`).
> To point at your own Firebase project, run `flutterfire configure` to regenerate that file
> and drop in your own platform config files.

---

## Common commands

```bash
# Run on a connected device / emulator
flutter run

# Regenerate .g.dart files after changing models or providers
dart run build_runner build --delete-conflicting-outputs

# Watch mode (regenerates on save)
dart run build_runner watch --delete-conflicting-outputs

# Analyze & format
flutter analyze
dart format .

# Run tests
flutter test

# Build release artifacts
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

---

## Building & shipping test builds

The `scripts/` directory contains Dart helpers for versioning and shipping test builds to
testers via [AppSend](https://appsend.dev):

```bash
# Bump version, build, and upload — prints shareable install links
dart scripts/deploy_testing.dart --build

# Rebuild/reupload the current version without bumping
dart scripts/deploy_testing.dart --build --no-bump

# Bump the version only
dart scripts/bump_version.dart
```

`bump_version.dart` also updates `web/version.txt`, a cache-busting token read by the web loader
to detect new deployments. See `scripts/README.md` for full details.

---

## Security model

- **Authentication:** Firebase Auth (email/password). Every user has a `/users/{uid}` document
  whose `role` field drives authorization.
- **Firestore rules** (`firestore.rules`): helper functions gate access by role
  (`isSignedIn`, `isStaff`, `isAdmin`). Users can read/manage their own `users` doc and staff can
  read all; **only admins may change a user's role**. Applicants access their own applications,
  documents, and appointments; staff can read/review across users.
- **Storage rules** (`storage.rules`): user files are scoped to their `uid` to prevent
  cross-user access.
- **Audit logging:** sensitive actions are recorded in the `audit_logs` collection via
  `audit_cloud_service.dart`.
- **Offline support:** Firestore persistence is enabled in `main.dart` so cached data renders
  instantly on cold start and reconciles with the server in the background.

---

## Further documentation

The repo includes deeper reference docs (some predate the feature-driven refactor — the code is
the source of truth where they disagree):

| Doc                          | Contents                                             |
|------------------------------|------------------------------------------------------|
| `ARCHITECTURE.md`            | Original app-flow & data-flow diagrams               |
| `DATABASE_SCHEMA.md`         | Firestore schema details                             |
| `FILE_STRUCTURE.md`          | Detailed file-structure notes                        |
| `GETTING_STARTED.md` / `QUICK_START.md` / `SETUP_GUIDE.md` | Onboarding & setup guides       |
| `IMPLEMENTATION_STATUS.md`   | Current implementation status                        |
| `SCREEN_IMPLEMENTATION_GUIDE.md` | Screen-by-screen build guide                     |
| `DOCUMENTATION_INDEX.md`     | Index of all documentation                           |
| `docs/`                      | NIRA reference material                              |

---

*ID Express — bringing the National ID process online, end to end.*
