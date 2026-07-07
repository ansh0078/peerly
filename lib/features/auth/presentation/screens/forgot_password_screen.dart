import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/validators/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_banner.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, required this.onBackToSignIn});

  final VoidCallback onBackToSignIn;

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.restore, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Reset Password',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your email to receive a recovery code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 24),
                if (authState.hasError) AppErrorBanner(message: controller.errorMessage ?? 'Could not send code'),
                AppTextField(
                  label: 'Email Address',
                  hint: 'name@company.com',
                  icon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Send Code',
                  icon: null,
                  isLoading: authState.isLoading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final email = _emailController.text.trim();
                    final success = await controller.sendPasswordResetCode(email: email);
                    if (!context.mounted) return;
                    if (success) {
                      AppSnackbar.success(context, 'Recovery code sent to $email');
                      widget.onBackToSignIn();
                    }
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(onPressed: widget.onBackToSignIn, child: const Text('← Back to Sign In')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
