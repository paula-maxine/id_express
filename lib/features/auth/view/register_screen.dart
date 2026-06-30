import '../../../app_exporter.dart';

/// Register screen
class RegisterScreen extends ConsumerStatefulWidget {
  /// Creates a register screen
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = ref.read(emailProvider);
    final password = ref.read(passwordProvider);
    final phoneNumber = ref.read(phoneNumberProvider);
    final displayName = ref.read(displayNameProvider);

    ref.read(authLoadingProvider.notifier).set(true);
    ref.read(authErrorProvider.notifier).clear();

    try {
      final user = await ref
          .read(authServiceProvider)
          .registerWithEmailAndPassword(
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            displayName: displayName,
          );

      if (user != null && mounted) {
        context.go(applicantHomePath);
      }
    } on FirebaseAuthException catch (e) {
      ref
          .read(authErrorProvider.notifier)
          .set(e.message ?? 'Registration failed');
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
                    Text('Create Account', style: headline2),
                    const Spacing(of: spacing8),
                    Text(
                      'Register to get started',
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

                    // Display name field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) => validateRequired(v, 'Full Name'),
                      onChanged: (value) =>
                          ref.read(displayNameProvider.notifier).update(value),
                    ),
                    const Spacing(of: spacing16),

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

                    // Phone number field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+256XXXXXXXXX or 07XXXXXXXX',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: validatePhone,
                      onChanged: (value) =>
                          ref.read(phoneNumberProvider.notifier).update(value),
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
                      onFieldSubmitted: (_) => _register(),
                    ),
                    const Spacing(of: spacing32),

                    // Register button
                    AppButton(
                      onPressed: _register,
                      text: 'Register',
                      isLoading: isLoading,
                    ),
                    const Spacing(of: spacing16),

                    // Login link
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(loginPath),
                        child: Text('Already have an account? Login'),
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
