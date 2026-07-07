# Testing & Release Scripts

Scripts for versioning ID Express and shipping test builds to testers via
[AppSend](https://appsend.dev).

- [`bump_version.dart`](bump_version.dart) — bumps the app version
- [`deploy_testing.dart`](deploy_testing.dart) — builds + uploads test builds,
  returns shareable install links

Run all commands from the project root (`id_express/`).

## Quick Start

The typical end-to-end flow for shipping a new test build:

```bash
dart scripts/deploy_testing.dart --build
```

That's it — `deploy_testing.dart` bumps the version automatically (runs
`bump_version.dart` for you, e.g. `1.1.0+2 -> 1.2.0+3`, updating
`web/version.txt` too) before building and uploading. It prints a
ready-to-share tester message with the version number and install links for
Android and iOS.

Pass `--no-bump` if you want to rebuild/reupload the current version without
bumping (e.g. retrying a failed upload).

## deploy_testing.dart

Bumps the version, builds release artifacts, uploads them to AppSend, and
prints install links plus a copy-paste message for testers.

### What it does

1. Runs `scripts/bump_version.dart` (unless `--no-bump` is passed).
2. Reads the resulting `version+build` string (e.g. `1.2.0+3`) from
   `pubspec.yaml`.
3. (With `--build`) runs the Flutter release builds.
4. Uploads the IPA and/or APK to `https://api.appsend.dev/v1/uploads/`.
5. Prints each install link (`https://appsend.dev/i/{uid}`) and a formatted
   tester message.

### Usage

```bash
dart scripts/deploy_testing.dart [options]
```

| Option | Description |
| --- | --- |
| `--build` | Run the Flutter release builds first (IPA + split-per-abi APK). Omit to upload artifacts already on disk. |
| `--no-bump` | Skip the automatic version bump. |
| `--ios-only` | Only build/upload iOS. |
| `--android-only` | Only build/upload Android. |
| `--testers=a@x.com,b@y.com` | Invite testers by email (comma-separated, **max 5**). Forwarded to AppSend. |
| `--message="..."` | Override the build description sent to AppSend. Defaults to `ID Express <version> test build`. |

### Examples

```bash
# Bump version, build everything fresh, and upload both platforms
dart scripts/deploy_testing.dart --build

# Upload artifacts already sitting on disk (still bumps the version first)
dart scripts/deploy_testing.dart

# Rebuild/reupload the current version without bumping
dart scripts/deploy_testing.dart --build --no-bump

# iOS only, and invite a tester
dart scripts/deploy_testing.dart --ios-only --testers=me@example.com

# Android only with a custom message
dart scripts/deploy_testing.dart --android-only --build \
  --message="Fixes login crash + new review screen"
```

### Sample output

```text
[deploy_testing] Version: 1.2.0+3
[deploy_testing] Uploading iOS build (36.9MB) from build/ios/ipa/ID Express.ipa...
[deploy_testing] iOS -> https://appsend.dev/i/446b2a2b-...

============================================================
  TESTER MESSAGE (copy below)
============================================================

New version out (1.2.0+3) and here are the links:

Android
https://appsend.dev/i/<uid>

iOS
https://appsend.dev/i/446b2a2b-...

============================================================
```

### The 150MB cap (important)

AppSend rejects uploads over **150MB**. A plain `flutter build apk` produces a
fat APK (~400MB) that is **too big to upload**.

To stay under the cap, `--build` uses `flutter build apk --release
--split-per-abi` and uploads only the **arm64-v8a** APK (~40–60MB), which
covers virtually all modern phones.

Consequences:

- For a real Android share, **use `--build`** so the split APK is produced.
- Running without `--build` when only the fat `app-release.apk` exists on disk
  will print a warning and the upload will fail the size check. Rerun with
  `--build`.
- The IPA (~37MB) is always under the cap, so iOS works with or without
  `--build`.

### Artifact paths

The script looks for builds at these locations:

| Platform | Path |
| --- | --- |
| iOS | `build/ios/ipa/ID Express.ipa` |
| Android (split, preferred) | `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` |
| Android (fat, fallback) | `build/app/outputs/flutter-apk/app-release.apk` |

### AppSend API notes

- Endpoint: `POST https://api.appsend.dev/v1/uploads/` (the **trailing slash**
  is required).
- No API key required — builds are addressable by the returned `uid`.
- Response includes `uid`; the install link is `https://appsend.dev/i/{uid}`.
- `testers` accepts a maximum of 5 emails.

## bump_version.dart

Bumps `pubspec.yaml` and updates `web/version.txt` (the cache-busting token
read by the inline loader in `web/index.html`). Runs automatically as the
first step of `deploy_testing.dart` (unless `--no-bump` is passed), but can
also be run standalone:

```bash
dart scripts/bump_version.dart
```

Bump rules: **MINOR +1, BUILD +1** (PATCH resets to 0). Each major version has
20 minor slots (0–19); when minor reaches 19 it rolls over to the next major.

- `1.1.0+2` → `1.2.0+3`
- `2.19.0+25` → `3.0.0+26`

## Prerequisites

- Flutter SDK on `PATH` (only needed when using `--build`).
- For iOS builds: a Mac with Xcode and valid signing configured (the pipeline
  runs `flutter build ipa --release`).
- Internet access for the AppSend upload.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `... artifact is XMB, over AppSend 150MB cap` | Rerun with `--build` so the split-per-abi arm64 APK is produced. |
| `No APK found` | Rerun with `--build`, or build manually with `flutter build apk --release --split-per-abi`. |
| `AppSend allows a maximum of 5 testers` | Pass 5 or fewer emails to `--testers`. |
| `pubspec.yaml not found` | Run the command from the `id_express/` project root. |
| Upload failed (HTTP 4xx/5xx) | Check the printed response body; verify network access and that the file is under 150MB. |
