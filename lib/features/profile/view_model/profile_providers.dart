import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_providers.g.dart';

/// Whether profile is being saved
@Riverpod(keepAlive: true)
class ProfileSaving extends _$ProfileSaving {
  @override
  bool build() => false;

  void set(bool v) => state = v;
}

/// Profile save error
@Riverpod(keepAlive: true)
class ProfileError extends _$ProfileError {
  @override
  String build() => '';

  void set(String v) => state = v;
  void clear() => state = '';
}
