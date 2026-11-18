# Engineering Decisions

[Back to README](../README.md)

Each entry separates what the code shows (**Observed**) from a possible reason
(**Inference**). Inferences are not historical facts; the repository contains
no decision records.

## 1. No backend: client plus security rules

- **Observed:** all reads and writes go from the Flutter client to Firestore
  and Storage; `firestore.rules` and `storage.rules` carry every authorization
  check; there is no `functions/` directory.
- **Significance:** one deployable unit plus two rule files.
- **Trade-offs:** business invariants that rules cannot express (valid status
  transitions, queue-number uniqueness, notification fan-out) are not enforced
  server-side.
- **Inference:** chosen to keep the system small enough for one developer.

## 2. Role stored on the user document and read inside rules

- **Observed:** `role` lives in `users/{uid}`; rules call `get()` on it;
  the client streams it for routing.
- **Significance:** one source of truth for UI gating and enforcement; a
  change takes effect without re-login.
- **Trade-offs:** every rule evaluation that needs the role costs an extra
  document read; custom Auth claims were not used.

## 3. Feature-first folders with Riverpod code generation

- **Observed:** `lib/features/<feature>/{model,view,view_model,service}`,
  `@riverpod` / `@Riverpod(keepAlive: true)` everywhere, generated `.g.dart`
  committed, barrels per folder, a single `app_exporter.dart` import.
- **Significance:** features are easy to locate; providers double as the
  dependency-injection mechanism (`authServiceProvider`,
  `applicationServiceProvider`, ...).
- **Trade-offs:** services call `FirebaseFirestore.instance` directly rather
  than through an injected interface, which makes unit testing with fakes
  harder.

## 4. One Notifier per form field

- **Observed:** `application_form_providers.dart` declares a `keepAlive`
  Notifier for each field and a `clearApplicationForm` helper.
- **Significance:** values survive step changes and screen rebuilds without a
  form controller object.
- **Trade-offs:** many providers; state persists until explicitly cleared.

## 5. Hand-written maps with snake_case keys and ISO-8601 strings

- **Observed:** `lib/features/models/*` implement `fromMap` / `toMap` by hand,
  use snake_case keys, store dates as `toIso8601String()` and default missing
  values (`?? ''`, `?? false`).
- **Significance:** tolerant of partially populated documents; no code
  generation for models in the live path.
- **Trade-offs:** strings rather than Firestore `Timestamp`s; ordering relies on
  lexicographic ISO strings in local time. The earlier `lib/data/model/` layer
  used `json_serializable` instead, so two conventions coexist.

## 6. Derived status in the model, persisted opportunistically

- **Observed:** `effectiveStatus` on `AppointmentModel`, `sweepOverdue` batch
  on screen visit.
- **Significance:** correct display without a scheduler.
- **Trade-offs:** stored state only catches up when someone opens an
  appointments screen.
- **Inference:** avoids needing a scheduled Cloud Function.

## 7. Best-effort audit logging

- **Observed:** audit writes follow the primary write and swallow errors after
  logging.
- **Significance:** an audit outage never blocks a review.
- **Trade-offs:** the audit trail can miss entries; the write is not atomic
  with the status change.

## 8. Composite indexes declared in source

- **Observed:** `firestore.indexes.json` lists every compound query's index
  and `firebase.json` references it.
- **Significance:** a fresh project gets working queries with one
  `firebase deploy`.

## 9. Firestore offline persistence instead of a custom sync layer

- **Observed:** `main.dart` enables persistence with an unlimited cache; the
  sembast-based `lib/data/local/sync_service.dart` exists but is not imported by
  the live app.
- **Inference:** the SDK's own cache replaced an earlier custom offline queue.
