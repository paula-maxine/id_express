// Bumps the pubspec.yaml version and updates web/version.txt.
//
// web/version.txt holds the "version+build" cache-busting token read by the
// inline loader in web/index.html to detect new deployments and clear stale
// browser/service-worker caches.
//
// Usage:
//   dart scripts/bump_version.dart
//
// Version bump: MINOR +1, BUILD +1 (PATCH resets to 0).
// Each major version has 20 minor slots (0–19). When minor reaches 19 it rolls
// over: minor resets to 0 and major increments.
// Examples: 2.9.0+12 -> 2.10.0+13   |   2.19.0+25 -> 3.0.0+26

import 'dart:io';

void main(List<String> args) {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr.writeln('Error: pubspec.yaml not found in the current directory.');
    exit(1);
  }

  final content = pubspecFile.readAsStringSync();
  final versionRegex = RegExp(
    r'^(version:\s*)(\d+)\.(\d+)\.(\d+)\+(\d+)',
    multiLine: true,
  );

  final match = versionRegex.firstMatch(content);
  if (match == null) {
    stderr.writeln('Error: could not parse version from pubspec.yaml.');
    exit(1);
  }

  final prefix = match.group(1)!;
  final major = int.parse(match.group(2)!);
  final minor = int.parse(match.group(3)!);
  // Patch is intentionally ignored and always resets to 0 on a minor bump.
  final build = int.parse(match.group(5)!);

  final oldVersion = '$major.$minor.0+$build';
  final newBuild = build + 1;
  // Each major version has 20 minor slots (0–19). Roll major when minor hits 19.
  final newMajor = minor >= 19 ? major + 1 : major;
  final newMinor = minor >= 19 ? 0 : minor + 1;
  final newVersion = '$newMajor.$newMinor.0+$newBuild';
  final shortVersion = '$newMajor.$newMinor.0';
  // Full "version+build" string used as the web cache-busting token.
  final fullVersion = '$shortVersion+$newBuild';

  // Update pubspec.yaml.
  pubspecFile.writeAsStringSync(
    content.replaceFirst(versionRegex, '$prefix$newVersion'),
  );
  stdout.writeln('Updated pubspec.yaml: $oldVersion -> $newVersion');

  // Update web/version.txt — the cache-busting token read by the inline loader
  // in web/index.html to detect new deployments and clear stale caches.
  File('web/version.txt').writeAsStringSync('$fullVersion\n');
  stdout.writeln('Updated web/version.txt: $fullVersion');
}
