import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerly/core/database/onboarding_status_service.dart';
import 'package:peerly/core/database/secure_storage_service.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/session/current_user_provider.dart';
import '../../../auth/domain/entities/auth_user.dart';

/// Splash has no domain/data layer of its own -- its only job is a
/// brief brand moment plus one routing decision, now with three
/// possible outcomes instead of two:
/// 1. Already has a saved auth token -> straight to Dashboard.
/// 2. No token, but has seen onboarding before -> straight to Welcome.
/// 3. First launch ever -> Onboarding.
class SplashScreen extends ConsumerStatefulWidget {
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
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    final results = await Future.wait([
      getIt<OnboardingStatusService>().hasSeenOnboarding(),
      getIt<SecureStorageService>().readAuthToken(),
      getIt<SecureStorageService>().readPendingUser(),
      getIt<SecureStorageService>().readAuthUser(),
      Future.delayed(const Duration(seconds: 3)), // minimum splash duration
    ]);
    final hasSeenOnboarding = results[0] as bool;
    final authToken = results[1] as String?;
    final pendingUser = results[2] as Map<String, String>?;
    final authUser = results[3] as AuthUser?;

    if (!mounted) return;
    if (authToken != null) {
      if (authUser != null) {
        ref.read(currentUserProvider.notifier).state = authUser;
      }
      widget.onNavigateToHome();
    } else if (pendingUser != null) {
      // Restore offline pending user session
      final user = AuthUser(
        id: const Uuid().v4(),
        name: pendingUser['name'] ?? '',
        email: pendingUser['email'] ?? '',
        isVerified: false,
      );
      ref.read(currentUserProvider.notifier).state = user;
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [const Color(0xFF4F46E5).withAlpha(60 ), Colors.white38],
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
