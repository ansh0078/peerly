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
  final AuthRemoteDataSource _remote;
  final ConnectivityService _connectivity;
  final SecureStorageService _secureStorage;
  final _uuid = const Uuid();

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required ConnectivityService connectivity,
    required SecureStorageService secureStorage,
  })  : _remote = remote,
        _connectivity = connectivity,
        _secureStorage = secureStorage;

  @override
  Future<AuthUser> signUp({required String name, required String email, required String password}) async {
    final online = await _connectivity.isOnline();

    if (!online) {
      final user = AuthUser(id: _uuid.v4(), name: name, email: email, isVerified: false);
      await _secureStorage.savePendingUser(name: name, email: email, password: password);
      return user;
    }

    return _remote.signUp(name: name, email: email, password: password);
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) async {
    final online = await _connectivity.isOnline();
    if (!online) throw const NoInternetException();

    final user = await _remote.signIn(email: email, password: password);
    if (user.token != null) {
      await _secureStorage.saveAuthToken(user.token!);
    }
    return user;
  }

  @override
  Future<AuthUser> verifyOtp({required String email, required String code}) async {
    final user = await _remote.verifyOtp(email: email, code: code);
    if (user.token != null) {
      await _secureStorage.saveAuthToken(user.token!);
    }
    await _secureStorage.clearPendingUser();
    return user;
  }

  @override
  Future<void> resendOtp({required String email}) => _remote.resendOtp(email: email);

  @override
  Future<void> sendPasswordResetCode({required String email}) => _remote.sendPasswordResetCode(email: email);
}
