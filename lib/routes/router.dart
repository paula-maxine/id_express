import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../app_exporter.dart';

part 'router.g.dart';

/// Routes reachable without being logged in
const _publicPaths = {
  welcomePath,
  loginPath,
  registerPath,
  otpVerifyPath,
};

/// Routes only applicants may access
const _applicantOnlyPaths = {applicantHomePath};

/// Routes only officers/supervisors/admins may access
const _staffOnlyPaths = {
  officerHomePath,
  officerDashboardPath,
  adminManageUsersPath,
};

/// Provides the app router
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: welcomePath,
    redirect: (context, state) {
      final firebaseUser = ref.watch(firebaseAuthUserProvider).value;
      final location = state.matchedLocation;

      if (firebaseUser == null) {
        return _publicPaths.contains(location) ? null : welcomePath;
      }

      final currentUser = ref.watch(currentUserProvider).value;
      if (currentUser == null) return null;

      final isStaff = currentUser.role != UserRole.applicant;

      if (_applicantOnlyPaths.contains(location) && isStaff) {
        return officerHomePath;
      }
      if (_staffOnlyPaths.contains(location) && !isStaff) {
        return applicantHomePath;
      }
      if (_publicPaths.contains(location)) {
        return isStaff ? officerHomePath : applicantHomePath;
      }

      return null;
    },
    routes: [
      GoRoute(path: welcomePath, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: loginPath, builder: (_, _) => const LoginScreen()),
      GoRoute(path: registerPath, builder: (_, _) => const RegisterScreen()),
      GoRoute(path: otpVerifyPath, builder: (_, _) => const _OtpVerifyScreen()),
      GoRoute(
        path: applicantHomePath,
        builder: (_, _) => const ApplicantHomeScreen(),
      ),
      GoRoute(
        path: officerHomePath,
        builder: (_, _) => const OfficerHomeScreen(),
      ),
      GoRoute(
        path: newApplicationPath,
        builder: (_, state) {
          final type = state.extra as ApplicationType?;
          return ApplicationFormScreen(applicationType: type);
        },
      ),
      GoRoute(
        path: applicationsListPath,
        builder: (_, _) => const ApplicationsScreen(),
      ),
      GoRoute(
        path: applicationDetailPath,
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return ApplicationDetailScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: documentsPath,
        builder: (_, state) {
          final application = state.extra as ApplicationModel?;
          return DocumentsScreen(
            applicationId: application?.applicationId ?? '',
          );
        },
      ),
      GoRoute(
        path: appointmentsPath,
        builder: (_, _) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: bookAppointmentPath,
        builder: (_, state) {
          final applicationId = state.extra as String? ?? '';
          return BookAppointmentScreen(applicationId: applicationId);
        },
      ),
      GoRoute(
        path: notificationsPath,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(path: profilePath, builder: (_, _) => const ProfileScreen()),
      GoRoute(
        path: officerDashboardPath,
        builder: (_, _) => const OfficerHomeScreen(),
      ),
      GoRoute(
        path: officerReviewPath,
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return OfficerReviewScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: adminManageUsersPath,
        builder: (_, _) => const ManageUsersScreen(),
      ),
    ],
  );
}

/// OTP verify screen placeholder — future implementation
class _OtpVerifyScreen extends StatelessWidget {
  const _OtpVerifyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: const Center(child: Text('OTP verification coming soon.')),
    );
  }
}
