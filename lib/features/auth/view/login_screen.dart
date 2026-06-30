import '../../../app_exporter.dart';

/// Login screen
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates a login screen
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = ref.read(emailProvider);
    final password = ref.read(passwordProvider);
    ref.read(authLoadingProvider.notifier).set(true);
    ref.read(authErrorProvider.notifier).clear();

    try {
      final user = await ref
          .read(authServiceProvider)
          .signInWithEmailAndPassword(email: email, password: password);

      if (user != null && mounted) {
        // Navigate based on user role
        if (user.isOfficer) {
          context.go(officerHomePath);
        } else {
          context.go(applicantHomePath);
        }
      }
    } on FirebaseAuthException catch (e) {
      ref.read(authErrorProvider.notifier).set(e.message ?? 'Login failed');
    } finally {
      ref.read(authLoadingProvider.notifier).set(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);
    final error = ref.watch(authErrorProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(welcomePath),
        ),
      ),
      body: KeyboardUnfocusWrapper(
        child: SafeArea(
          child: BodyWidth(
            maxWidth: 600,
            child: SingleChildScrollView(
              padding: padding24,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacing(of: spacing32),

                    // Title
                    Text('Welcome Back', style: headline2),
                    const Spacing(of: spacing8),
                    Text(
                      'Login to continue',
                      style: bodyMedium.copyWith(color: mediumGrey),
                    ),
                    const Spacing(of: spacing32),

                    // Error message
                    if (error.isNotEmpty) ...[
                      Container(
                        padding: padding12,
                        decoration: BoxDecoration(
                          color: errorRed.withValues(alpha: 0.1),
                          borderRadius: borderRadius8,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: errorRed),
                            const SizedBox(width: spacing12),
                            Expanded(
                              child: Text(
                                error,
                                style: bodyMedium.copyWith(color: errorRed),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacing(of: spacing24),
                    ],

                    // Email field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      onChanged: (value) =>
                          ref.read(emailProvider.notifier).update(value),
                    ),
                    const Spacing(of: spacing16),

                    // Password field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: validatePassword,
                      onChanged: (value) =>
                          ref.read(passwordProvider.notifier).update(value),
                      onFieldSubmitted: (_) => _login(),
                    ),
                    const Spacing(of: spacing32),

                    // Login button
                    AppButton(
                      onPressed: _login,
                      text: 'Login',
                      isLoading: isLoading,
                    ),
                    const Spacing(of: spacing16),

                    // Register link
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(registerPath),
                        child: Text('Don\'t have an account? Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
