import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/validators/validators.dart';
import '../../../../core/session/current_user_provider.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_banner.dart';
import '../../../../shared/widgets/social_auth_button.dart';
import '../providers/auth_providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onSignedUpOnline,
    required this.onSignedUpOffline,
    required this.onSignIn,
  });

  /// Online success -> caller should push the OTP screen.
  final void Function(String email) onSignedUpOnline;

  /// Offline success -> caller should skip OTP and go straight into the app.
  final VoidCallback onSignedUpOffline;

  final VoidCallback onSignIn;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join the offline-first campus network',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 24),
                if (authState.hasError) AppErrorBanner(message: controller.errorMessage ?? 'Something went wrong'),
                AppTextField(
                  label: 'Full Name',
                  hint: 'Jane Doe',
                  icon: Icons.person_outline,
                  controller: _nameController,
                  validator: Validators.fullName,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email Address',
                  hint: 'jane@example.com',
                  icon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 20),
                Text(
                  'By signing up, you agree to our Terms of Service and Privacy Policy.',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: 'Create Account',
                  icon: null,
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final success = await controller.signUp(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );
                    if (!context.mounted || !success) return;

                    // AuthRepositoryImpl already decided online vs.
                    // offline -- this screen just reads the result off
                    // the shared session to decide where to navigate.
                    final user = ref.read(currentUserProvider);
                    if (user != null && !user.isVerified) {
                      widget.onSignedUpOffline();
                    } else {
                      widget.onSignedUpOnline(_emailController.text.trim());
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('OR CONTINUE WITH', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: SocialAuthButton(label: 'Google', icon: const Icon(Icons.g_mobiledata, size: 22))),
                    const SizedBox(width: 12),
                    Expanded(child: SocialAuthButton(label: 'Apple', icon: const Icon(Icons.apple, size: 20))),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: widget.onSignIn,
                    child: const Text.rich(TextSpan(
                      text: 'Already have an account? ',
                      children: [TextSpan(text: 'Sign In', style: TextStyle(fontWeight: FontWeight.bold))],
                    )),
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
