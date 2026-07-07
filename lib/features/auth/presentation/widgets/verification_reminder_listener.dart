import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/session/current_user_provider.dart';
import '../../../../shared/widgets/app_snackbar.dart';

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
    ref.listen(onlineStatusProvider, (previous, next) {
      final justCameOnline = previous?.valueOrNull == false && next.valueOrNull == true;
      final user = ref.read(currentUserProvider);
      if (justCameOnline && user != null && !user.isVerified) {
        AppSnackbar.warning(
          context,
          "You're back online — verify your email now?",
          actionLabel: 'Verify',
          onAction: onVerifyRequested,
        );
      }
    });
    return child;
  }
}
