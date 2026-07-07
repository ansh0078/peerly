import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/auth_user.dart';

/// The single source of truth for "who's logged in right now."
/// Dashboard reads the display name from here (not from features/auth
/// directly), and VerificationReminderListener reads isVerified from
/// here too -- this is the shared session home flagged as missing
/// during the architecture review, now filled in.
final currentUserProvider = StateProvider<AuthUser?>((ref) => null);
