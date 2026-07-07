import 'package:flutter/material.dart';
import 'package:peerly/core/database/onboarding_status_service.dart';
import 'package:peerly/core/database/secure_storage_service.dart';
import '../../../../core/di/injection.dart';

/// Splash has no domain/data layer of its own -- its only job is a
/// brief brand moment plus one routing decision, now with three
/// possible outcomes instead of two:
/// 1. Already has a saved auth token -> straight to Dashboard.
/// 2. No token, but has seen onboarding before -> straight to Welcome.
/// 3. First launch ever -> Onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onNavigateToOnboarding,
    required this.onNavigateToWelcome,
    required this.onNavigateToHome,
  });

  final VoidCallback onNavigateToOnboarding;
  final VoidCallback onNavigateToWelcome;
  final VoidCallback onNavigateToHome;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    final results = await Future.wait([
      getIt<OnboardingStatusService>().hasSeenOnboarding(),
      getIt<SecureStorageService>().readAuthToken(),
      Future.delayed(const Duration(milliseconds: 1400)), // minimum splash duration
    ]);
    final hasSeenOnboarding = results[0] as bool;
    final authToken = results[1] as String?;

    if (!mounted) return;
    if (authToken != null) {
      widget.onNavigateToHome();
    } else if (hasSeenOnboarding) {
      widget.onNavigateToWelcome();
    } else {
      widget.onNavigateToOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFF4F46E5).withOpacity(0.15), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.all(40),
              child: Image.asset(
                'assets/logo/peerly_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.hub_outlined, size: 64, color: Color(0xFF4F46E5)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Peerly',
              style: TextStyle(fontSize: 28, color: Color(0xFF4F46E5), fontWeight: FontWeight.w600),
            ),
            const Spacer(flex: 4),
            const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Text(
                'FROM THE DECENTRALIZED WEB',
                style: TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
