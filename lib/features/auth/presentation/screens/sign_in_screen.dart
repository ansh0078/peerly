import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/validators/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_banner.dart';
import '../providers/auth_providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({
    super.key,
    required this.onSignedIn,
    required this.onForgotPassword,
    required this.onCreateAccount,
  });

  final VoidCallback onSignedIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
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
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to sync your mesh network.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 24),
                if (authState.hasError) AppErrorBanner(message: controller.errorMessage ?? 'Sign in failed'),
                AppTextField(
                  label: 'Email Address',
                  hint: 'name@example.com',
                  icon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: widget.onForgotPassword,
                      child: const Text('Forgot Password?', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppTextField(
                  label: '',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.requiredPassword,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Sign In',
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final success = await controller.signIn(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );
                    if (!context.mounted) return;
                    if (success) widget.onSignedIn();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('OR', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.smartphone),
                  label: const Text('Sign in with Device ID'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: widget.onCreateAccount,
                    child: const Text.rich(TextSpan(
                      text: "Don't have an account? ",
                      children: [TextSpan(text: 'Create Account', style: TextStyle(fontWeight: FontWeight.bold))],
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
