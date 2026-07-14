import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/domain/entities/auth_user.dart';

/// The ONLY file that touches flutter_secure_storage directly. Holds
/// the auth token once a real sign-in succeeds, plus the "pending"
/// account created during an offline signup -- cached locally until
/// connectivity returns and the real signup call can be retried.
class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const _pendingNameKey = 'pending_name';
  static const _pendingEmailKey = 'pending_email';
  static const _pendingPasswordKey = 'pending_password';
  static const _authTokenKey = 'auth_token';
  static const _authUserKey = 'auth_user';

  Future<void> savePendingUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _pendingNameKey, value: name);
    await _storage.write(key: _pendingEmailKey, value: email);
    await _storage.write(key: _pendingPasswordKey, value: password);
  }

  Future<Map<String, String>?> readPendingUser() async {
    final email = await _storage.read(key: _pendingEmailKey);
    if (email == null) return null;
    return {
      'name': await _storage.read(key: _pendingNameKey) ?? '',
      'email': email,
      'password': await _storage.read(key: _pendingPasswordKey) ?? '',
    };
  }

  Future<void> clearPendingUser() async {
    await _storage.delete(key: _pendingNameKey);
    await _storage.delete(key: _pendingEmailKey);
    await _storage.delete(key: _pendingPasswordKey);
  }

  Future<void> saveAuthToken(String token) => _storage.write(key: _authTokenKey, value: token);
  Future<String?> readAuthToken() => _storage.read(key: _authTokenKey);
  Future<void> clearAuthToken() => _storage.delete(key: _authTokenKey);

  Future<void> saveAuthUser(AuthUser user) async {
    final data = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'isVerified': user.isVerified,
      'token': user.token,
    };
    await _storage.write(key: _authUserKey, value: jsonEncode(data));
  }

  Future<AuthUser?> readAuthUser() async {
    final jsonStr = await _storage.read(key: _authUserKey);
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AuthUser(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        isVerified: map['isVerified'] as bool? ?? false,
        token: map['token'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAuthUser() async {
    await _storage.delete(key: _authUserKey);
  }
}
