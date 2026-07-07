import '../entities/auth_user.dart';

/// Every auth screen's ViewModel talks only to this interface -- never
/// to Dio, connectivity_plus, or secure storage directly.
abstract class AuthRepository {
  /// Returns the created user. If the device is offline, this succeeds
  /// LOCALLY with isVerified=false instead of throwing -- that's the
  /// deferred-verification design decided earlier. If online, this
  /// succeeds with isVerified=false too, but the caller is expected to
  /// route to the OTP screen next.
  Future<AuthUser> signUp({required String name, required String email, required String password});

  /// Requires connectivity -- signing in to sync an existing account
  /// against a device with no local copy of it doesn't have an offline
  /// fallback the way signup does.
  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> verifyOtp({required String email, required String code});

  Future<void> resendOtp({required String email});

  Future<void> sendPasswordResetCode({required String email});
}
