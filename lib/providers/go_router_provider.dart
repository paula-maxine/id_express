import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/paths.dart';
import '../routes/error_page.dart';
import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userRole = ref.watch(userRoleProvider);

  return GoRouter(
    redirect: (context, state) async {
      final isLoading = authState.isLoading;
      final user = authState.whenData((data) => data).value;
      final role = userRole.whenData((data) => data).value;

      // Show splash while loading
      if (isLoading) {
        return RoutesPaths.splash;
      }

      // No user logged in
      if (user == null) {
        // Allow access to public routes
        if (state.matchedLocation == RoutesPaths.login ||
            state.matchedLocation == RoutesPaths.signup ||
            state.matchedLocation == RoutesPaths.forgotPassword) {
          return null;
        }
        // Redirect to login
        return RoutesPaths.login;
      }

      // User logged in but role not loaded yet
      if (role == null) {
        return RoutesPaths.splash;
      }

      // Redirect based on role
      if (state.matchedLocation == RoutesPaths.login ||
          state.matchedLocation == RoutesPaths.signup ||
          state.matchedLocation == RoutesPaths.forgotPassword) {
        // Redirect logged in users away from auth screens
        if (role == 'applicant') {
          return RoutesPaths.applicantDashboard;
        } else if (role == 'officer' || role == 'supervisor') {
          return RoutesPaths.officerDashboard;
        } else if (role == 'admin') {
          return RoutesPaths.adminDashboard;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutesPaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutesPaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutesPaths.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      // TODO: Add ForgotPasswordScreen when implemented
      GoRoute(
        path: RoutesPaths.forgotPassword,
        builder: (context, state) => const Placeholder(),
      ),
      // Applicant dashboard: use UploadScreen as placeholder for now
      GoRoute(
        path: RoutesPaths.applicantDashboard,
        builder: (context, state) => const UploadScreen(),
      ),
      // Officer dashboard placeholder
      GoRoute(
        path: RoutesPaths.officerDashboard,
        builder: (context, state) => const Placeholder(),
      ),
      // Admin dashboard placeholder
      GoRoute(
        path: RoutesPaths.adminDashboard,
        builder: (context, state) => const Placeholder(),
      ),
      // Settings placeholder
      GoRoute(
        path: RoutesPaths.settings,
        builder: (context, state) => const Placeholder(),
      ),
      // Privacy policy placeholder
      GoRoute(
        path: RoutesPaths.privacyPolicy,
        builder: (context, state) => const Placeholder(),
      ),
    ],
    errorBuilder: (context, state) =>
        ErrorPage(message: state.error?.message ?? 'Unknown error'),
  );
});
