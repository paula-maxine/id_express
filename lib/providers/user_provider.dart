import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/user_model.dart';
import 'service_providers.dart';

// Get users by role
final usersByRoleProvider =
    FutureProvider.family<List<UserModel>, String>((ref, role) async {
  final userService = ref.watch(userCloudServiceProvider);
  return userService.getUsersByRole(role);
});

// Single user provider
final userProvider =
    FutureProvider.family<UserModel?, String>((ref, uid) async {
  final userService = ref.watch(userCloudServiceProvider);
  return userService.getUser(uid);
});
