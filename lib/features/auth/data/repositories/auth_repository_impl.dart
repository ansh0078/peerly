import 'package:peerly/core/database/secure_storage_service.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/network_exceptions.dart';

/// This is the file that actually implements "works online AND
/// offline" auth. signUp() is the method that branches: online calls
/// the real backend and expects an OTP step next; offline creates a
/// local, unverified account so the user can keep using the app
/// immediately, with verification deferred until connectivity returns
/// (see VerificationReminderListener).
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final ConnectivityService connectivity;
  final SecureStorageService secureStorage;
  final _uuid = const Uuid();

  AuthRepositoryImpl({
    required this.remote,
    required this.connectivity,
    required this.secureStorage,
  });

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final online = await connectivity.isOnline();

    if (!online) {
      final user = AuthUser(
        id: _uuid.v4(),
        name: name,
        email: email,
        isVerified: false,
      );
      await secureStorage.savePendingUser(
        name: name,
        email: email,
        password: password,
      );
      return user;
    }

    return remote.signUp(name: name, email: email, password: password);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final online = await connectivity.isOnline();
    if (!online) throw const NoInternetException();

    final user = await remote.signIn(email: email, password: password);
    if (user.token != null) {
      await secureStorage.saveAuthToken(user.token!);
    }
    await secureStorage.saveAuthUser(user);
    return user;
  }

  @override
  Future<AuthUser> verifyOtp({
    required String email,
    required String code,
  }) async {
    final user = await remote.verifyOtp(email: email, code: code);
    if (user.token != null) {
      await secureStorage.saveAuthToken(user.token!);
    }
    await secureStorage.saveAuthUser(user);
    await secureStorage.clearPendingUser();
    return user;
  }

  @override
  Future<void> resendOtp({required String email}) =>
      remote.resendOtp(email: email);

  @override
  Future<void> sendPasswordResetCode({required String email}) =>
      remote.sendPasswordResetCode(email: email);
}
