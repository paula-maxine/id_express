// Testing pipeline: builds release artifacts, uploads them to AppSend, and
// prints ready-to-share install links + a tester message.
//
// AppSend upload endpoint (multipart/form-data, note trailing slash):
//   https://api.appsend.dev/v1/uploads/
// Fields: file=@build.{apk|ipa}, message=..., testers=a@x.com,b@y.com (max 5)
// Response: { "uid": "...", ... }  ->  https://appsend.dev/i/{uid}
//
// AppSend caps uploads at 150MB, so the Android build uses --split-per-abi and
// we upload the arm64-v8a APK (covers virtually all modern phones).
//
// Usage:
//   dart scripts/deploy_testing.dart [options]
//
// Options:
//   --build            Run flutter builds first (IPA + split-per-abi APK).
//                      Omit to upload the artifacts already on disk.
//   --no-bump          Skip the version bump (scripts/bump_version.dart runs
//                      by default before every build/upload).
//   --android-only     Only build/upload Android.
//   --ios-only         Only build/upload iOS.
//   --testers=a@x.com,b@y.com   Invite testers (max 5, forwarded to AppSend).
//   --message="..."    Override the build description sent to AppSend.
//
// Examples:
//   dart scripts/deploy_testing.dart --build
//   dart scripts/deploy_testing.dart            # upload existing artifacts
//   dart scripts/deploy_testing.dart --ios-only --testers=me@x.com
//   dart scripts/deploy_testing.dart --build --no-bump   # reupload same version

import 'dart:convert';
import 'dart:io';

const _uploadEndpoint = 'https://api.appsend.dev/v1/uploads/';
const _installUrlBase = 'https://appsend.dev/i';
const _maxUploadBytes = 150 * 1024 * 1024; // AppSend 150MB cap.

// Flutter names the IPA after the Xcode product name, which can drift from
// the app's display name — resolve whatever .ipa lands here rather than
// hardcoding a filename.
const _ipaDir = 'build/ios/ipa';
// --split-per-abi writes here; arm64-v8a is the target for modern phones.
const _apkArm64Path =
    'build/app/outputs/flutter-apk/app-arm64-v8a-release.apk';
// Fallback: the fat APK from a plain `flutter build apk`.
const _apkFatPath = 'build/app/outputs/flutter-apk/app-release.apk';

Future<void> main(List<String> args) async {
  final flags = args.where((a) => a.startsWith('--')).toList();
  bool has(String name) => flags.any((f) => f == '--$name');
  String? value(String name) {
    final prefix = '--$name=';
    final hit = flags.firstWhere(
      (f) => f.startsWith(prefix),
      orElse: () => '',
    );
    return hit.isEmpty ? null : hit.substring(prefix.length);
  }

  final doBuild = has('build');
  final noBump = has('no-bump');
  final iosOnly = has('ios-only');
  final androidOnly = has('android-only');
  final testers = value('testers');
  final messageOverride = value('message');

  final doAndroid = !iosOnly;
  final doIos = !androidOnly;

  if (!noBump) await _bumpVersion();

  final version = _readVersion();
  final message = messageOverride ?? 'ID Express $version test build';
  _log('Version: $version');

  if (testers != null) {
    final count = testers.split(',').where((e) => e.trim().isNotEmpty).length;
    if (count > 5) {
      _fail('AppSend allows a maximum of 5 testers (got $count).');
    }
    _log('Testers: $testers');
  }

  if (doBuild) {
    if (doIos) await _buildIpa();
    if (doAndroid) await _buildApk();
  }

  final results = <_UploadResult>[];

  if (doAndroid) {
    final apk = _resolveApk();
    results.add(
      await _upload(
        platform: 'Android',
        file: apk,
        message: message,
        testers: testers,
      ),
    );
  }

  if (doIos) {
    final ipa = _resolveIpa();
    results.add(
      await _upload(
        platform: 'iOS',
        file: ipa,
        message: message,
        testers: testers,
      ),
    );
  }

  _printSummary(version: version, results: results);
}

/// Runs scripts/bump_version.dart so every deploy ships a fresh version+build.
Future<void> _bumpVersion() async {
  _log('Bumping version (dart scripts/bump_version.dart)...');
  await _run('dart', ['scripts/bump_version.dart']);
}

/// Reads the "version+build" string from pubspec.yaml (e.g. 1.1.0+2).
String _readVersion() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    _fail('pubspec.yaml not found. Run from the id_express/ project root.');
  }
  final match = RegExp(r'^version:\s*(\S+)', multiLine: true)
      .firstMatch(pubspec.readAsStringSync());
  if (match == null) _fail('Could not parse version from pubspec.yaml.');
  return match.group(1)!;
}

Future<void> _buildIpa() async {
  _log('Building IPA (flutter build ipa --release)...');
  await _run('flutter', ['build', 'ipa', '--release']);
}

Future<void> _buildApk() async {
  _log('Building split-per-abi APKs (flutter build apk --release '
      '--split-per-abi)...');
  await _run('flutter', ['build', 'apk', '--release', '--split-per-abi']);
}

/// Prefers the split arm64-v8a APK; falls back to the fat APK if that is the
/// only artifact present. Fails clearly if neither exists.
File _resolveIpa() {
  final dir = Directory(_ipaDir);
  if (dir.existsSync()) {
    final ipas = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.ipa'))
        .toList();
    if (ipas.length > 1) {
      _log('WARNING: multiple .ipa files in $_ipaDir; using ${ipas.first.path}.');
    }
    if (ipas.isNotEmpty) return ipas.first;
  }
  _fail('No IPA found in $_ipaDir (rerun with --build).');
}

File _resolveApk() {
  final arm64 = File(_apkArm64Path);
  if (arm64.existsSync()) return arm64;
  final fat = File(_apkFatPath);
  if (fat.existsSync()) {
    _log('WARNING: split arm64 APK not found; using the fat APK at '
        '$_apkFatPath. If it exceeds 150MB the upload will fail — '
        'rerun with --build to produce a split-per-abi APK.');
    return fat;
  }
  _fail('No APK found. Expected $_apkArm64Path (or rerun with --build).');
}

Future<_UploadResult> _upload({
  required String platform,
  required File file,
  required String message,
  String? testers,
}) async {
  if (!file.existsSync()) {
    _fail('$platform artifact not found: ${file.path}');
  }
  final size = file.lengthSync();
  final sizeMb = (size / (1024 * 1024)).toStringAsFixed(1);
  if (size > _maxUploadBytes) {
    _fail('$platform artifact is ${sizeMb}MB, over AppSend 150MB cap: '
        '${file.path}');
  }
  _log('Uploading $platform build (${sizeMb}MB) from ${file.path}...');

  final request = await HttpClient().postUrl(Uri.parse(_uploadEndpoint));
  final boundary =
      '----idExpressAppSend${DateTime.now().microsecondsSinceEpoch}';
  request.headers.set(
    HttpHeaders.contentTypeHeader,
    'multipart/form-data; boundary=$boundary',
  );

  final body = <int>[];
  void field(String name, String val) {
    body
      ..addAll(utf8.encode('--$boundary\r\n'))
      ..addAll(utf8.encode(
          'Content-Disposition: form-data; name="$name"\r\n\r\n'))
      ..addAll(utf8.encode('$val\r\n'));
  }

  field('message', message);
  if (testers != null && testers.trim().isNotEmpty) {
    field('testers', testers.trim());
  }

  final fileName = file.uri.pathSegments.last;
  body
    ..addAll(utf8.encode('--$boundary\r\n'))
    ..addAll(utf8.encode(
      'Content-Disposition: form-data; name="file"; '
      'filename="$fileName"\r\n',
    ))
    ..addAll(utf8.encode(
        'Content-Type: application/octet-stream\r\n\r\n'))
    ..addAll(file.readAsBytesSync())
    ..addAll(utf8.encode('\r\n'))
    ..addAll(utf8.encode('--$boundary--\r\n'));

  request.headers.set(HttpHeaders.contentLengthHeader, body.length);
  request.add(body);

  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();

  if (response.statusCode < 200 || response.statusCode >= 300) {
    _fail('$platform upload failed (HTTP ${response.statusCode}): '
        '$responseBody');
  }

  final uid = (jsonDecode(responseBody) as Map<String, dynamic>)['uid']
      as String?;
  if (uid == null || uid.isEmpty) {
    _fail('$platform upload succeeded but response had no uid: $responseBody');
  }

  final url = '$_installUrlBase/$uid';
  _log('$platform -> $url');
  return _UploadResult(platform: platform, url: url);
}

void _printSummary({
  required String version,
  required List<_UploadResult> results,
}) {
  final android = results.where((r) => r.platform == 'Android').firstOrNull;
  final ios = results.where((r) => r.platform == 'iOS').firstOrNull;

  final buffer = StringBuffer()
    ..writeln('\n${'=' * 60}')
    ..writeln('  TESTER MESSAGE (copy below)')
    ..writeln('=' * 60)
    ..writeln()
    ..writeln('New version out ($version) and here are the links:');
  if (android != null) {
    buffer
      ..writeln()
      ..writeln('Android')
      ..writeln(android.url);
  }
  if (ios != null) {
    buffer
      ..writeln()
      ..writeln('iOS')
      ..writeln(ios.url);
  }
  buffer.writeln('\n${'=' * 60}');
  stdout.writeln(buffer.toString());
}

Future<void> _run(String cmd, List<String> args) async {
  final process = await Process.start(
    cmd,
    args,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) _fail('`$cmd ${args.join(' ')}` failed (exit $code).');
}

void _log(String msg) => stdout.writeln('[deploy_testing] $msg');

Never _fail(String msg) {
  stderr.writeln('[deploy_testing] ERROR: $msg');
  exit(1);
}

class _UploadResult {
  const _UploadResult({required this.platform, required this.url});
  final String platform;
  final String url;
}
