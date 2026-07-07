import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_banner.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../providers/auth_providers.dart';
import '../widgets/otp_digit_boxes.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.email, required this.onVerified});

  final String email;
  final VoidCallback onVerified;

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _code = '';
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    await ref.read(authRepositoryProvider).resendOtp(email: widget.email);
    if (!mounted) return;
    _startResendTimer();
    AppSnackbar.success(context, 'A new code was sent to ${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
              const SizedBox(height: 16),
              Text(
                'Verify your Identity',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text("We've sent a code to your email."),
              const SizedBox(height: 24),
              if (authState.hasError) AppErrorBanner(message: controller.errorMessage ?? 'Invalid code'),
              OtpDigitBoxes(length: 6, onChanged: (value) => setState(() => _code = value)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Didn't receive code? "),
                  TextButton(
                    onPressed: _secondsLeft == 0 ? _resend : null,
                    child: Text(_secondsLeft == 0 ? 'Resend' : 'Resend in 00:${_secondsLeft.toString().padLeft(2, '0')}'),
                  ),
                ],
              ),
              const Spacer(),
              AppButton(
                label: 'Verify & Continue',
                isLoading: authState.isLoading,
                onPressed: _code.length == 6
                    ? () async {
                        final success = await controller.verifyOtp(email: widget.email, code: _code);
                        if (!context.mounted) return;
                        if (success) {
                          AppSnackbar.success(context, 'Email verified!');
                          widget.onVerified();
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
