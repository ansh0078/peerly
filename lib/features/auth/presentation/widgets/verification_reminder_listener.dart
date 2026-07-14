import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/secure_storage_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/session/current_user_provider.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../providers/auth_providers.dart';
import '../screens/otp_verification_screen.dart';

/// Wraps DashboardScreen. Watches for offline->online transitions and,
/// if the current user is unverified, nudges them once per transition
/// -- never blocking, matching the "ask once, don't nag" decision made
/// earlier for deferred verification.
final onlineStatusProvider = StreamProvider<bool>((ref) {
  return getIt<ConnectivityService>().onOnlineStatusChanged;
});

class VerificationReminderListener extends ConsumerWidget {
  const VerificationReminderListener({super.key, required this.child, this.onVerifyRequested});

  final Widget child;
  final VoidCallback? onVerifyRequested;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(onlineStatusProvider, (previous, next) async {
      final justCameOnline = previous?.valueOrNull == false && next.valueOrNull == true;
      if (!justCameOnline) return;

      final user = ref.read(currentUserProvider);
      if (user == null || user.isVerified) return;

      final secureStorage = getIt<SecureStorageService>();
      final pending = await secureStorage.readPendingUser();

      if (pending != null) {
        try {
          // Register the offline user on the server to trigger OTP dispatch
          await ref.read(authRepositoryProvider).signUp(
                name: pending['name']!,
                email: pending['email']!,
                password: pending['password']!,
              );
        } catch (e) {
          // If background registration fails, we shouldn't show the verification prompt yet
          if (context.mounted) {
            AppSnackbar.error(context, "Unable to register account on server: $e");
          }
          return;
        }
      }

      if (context.mounted) {
        AppSnackbar.warning(
          context,
          "You're back online — verify your email now?",
          actionLabel: 'Verify',
          onAction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpVerificationScreen(
                  email: user.email,
                  onVerified: () {
                    // State automatically transitions upon verification
                  },
                ),
              ),
            );
          },
        );
      }
    });
    return child;
  }
}
