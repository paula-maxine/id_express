import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_providers.g.dart';

/// Tracks which user row currently has a role change in flight
@riverpod
class RoleAssignmentLoading extends _$RoleAssignmentLoading {
  @override
  String? build() => null;

  /// Sets the user ID currently being updated, or null when idle
  void set(String? userId) => state = userId;
}
