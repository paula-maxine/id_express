import '../../../app_exporter.dart';

/// Welcome screen - landing page
class WelcomeScreen extends ConsumerWidget {
  /// Creates a welcome screen
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: facebookBlue,
      body: SafeArea(
        child: BodyWidth(
          maxWidth: 600,
          child: Padding(
            padding: padding24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.badge, size: 64, color: facebookBlue),
                ),
                const Spacing(of: spacing32),

                // App name
                Text(
                  'ID Express',
                  style: headline1.copyWith(color: whiteColor),
                ),
                const Spacing(of: spacing8),

                // Tagline
                Text(
                  'National ID Registration Made Easy',
                  style: bodyLarge.copyWith(
                    color: whiteColor.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacing(of: spacing64),

                // Login button
                AppButton(
                  onPressed: () => context.go(loginPath),
                  text: 'Login',
                ),
                const Spacing(of: spacing16),

                // Register button
                AppOutlinedButton(
                  onPressed: () => context.go(registerPath),
                  text: 'Register',
                ),
                const Spacing(of: spacing32),

                // Info text
                Text(
                  'Powered by NIRA',
                  style: bodySmall.copyWith(
                    color: whiteColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
