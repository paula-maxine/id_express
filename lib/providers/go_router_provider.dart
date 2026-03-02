import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:id_express/screens/signup_screen.dart';

import '../providers/auth_provider.dart';
import '../routes/error_page.dart';
import '../routes/paths.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/applicant/applicant_dashboard.dart';
import '../screens/applicant/appointments/book_appointment_screen.dart';
import '../screens/applicant/pre_registration_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/officer/daily_appointments_screen.dart';
import '../screens/officer/officer_dashboard.dart';
import '../screens/officer/pending_applications_screen.dart';
import '../screens/settings/privacy_policy_screen.dart';
import '../screens/settings/settings_screen.dart';
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
      // if (isLoading) {
      //   return RoutesPaths.splash;
      // }

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
      // if (role == null) {
      //   return RoutesPaths.splash;
      // }

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
    initialLocation: RoutesPaths.home,
    routes: [
      GoRoute(
        path: RoutesPaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
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
      GoRoute(
        path: RoutesPaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Applicant dashboard
      GoRoute(
        path: RoutesPaths.applicantDashboard,
        builder: (context, state) => const ApplicantDashboard(),
        routes: [
          GoRoute(
            path: RoutesPaths.preRegistration.replaceFirst('/applicant', '').substring(1),
            builder: (context, state) => const PreRegistrationScreen(),
          ),
          GoRoute(
            path: RoutesPaths.bookAppointment.replaceFirst('/applicant', '').substring(1),
            builder: (context, state) {
              // applicationId must be passed via push; default to empty
              return const BookAppointmentScreen(applicationId: '');
            },
          ),
          GoRoute(
            path: RoutesPaths.appointmentDetails.replaceFirst('/applicant', '').substring(1),
            builder: (context, state) {
              // details route not used yet
              return const SizedBox();
            },
          ),
        ],
      ),
      // Officer dashboard
      GoRoute(
        path: RoutesPaths.officerDashboard,
        builder: (context, state) => const OfficerDashboard(),
        routes: [
          GoRoute(
            path: RoutesPaths.pendingApplications.replaceFirst('/officer', '').substring(1),
            builder: (context, state) => const PendingApplicationsScreen(),
          ),
          GoRoute(
            path: RoutesPaths.dailyAppointments.replaceFirst('/officer', '').substring(1),
            builder: (context, state) => const DailyAppointmentsScreen(),
          ),
        ],
      ),
      // Admin dashboard
      GoRoute(
        path: RoutesPaths.adminDashboard,
        builder: (context, state) => const AdminDashboard(),
      ),
      // Settings
      GoRoute(
        path: RoutesPaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      // Privacy policy
      GoRoute(
        path: RoutesPaths.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        ErrorPage(message: state.error?.message ?? 'Unknown error'),
  );
});
