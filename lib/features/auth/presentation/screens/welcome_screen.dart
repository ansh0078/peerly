import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onCreateAccount,
    required this.onSignIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.23),
                      Theme.of(context).colorScheme.surface.withValues(alpha: 0.38),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(40),
                child: Image.asset(
                  'assets/logo/peerly_logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.hub_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Connect.\nCollaborate.\nLearn. Anywhere.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The secure, offline-first collaboration platform for students and teams.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const Spacer(flex: 4),
              AppButton(label: 'Create Account', onPressed: onCreateAccount),
              const SizedBox(height: 12),
              AppButton(
                label: 'Sign In',
                icon: null,
                outlined: true,
                onPressed: onSignIn,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
