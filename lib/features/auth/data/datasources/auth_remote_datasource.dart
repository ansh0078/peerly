import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/auth_user.dart';

/// Talks to the real backend only. Never called directly by a
/// ViewModel -- AuthRepositoryImpl decides whether to call this at all,
/// based on connectivity. Update the field names in `res.data[...]` to
/// match your actual Node/Express response shape once it exists.
class AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSource(this._client);

  Future<AuthUser> signUp({required String name, required String email, required String password}) async {
    try {
      final res = await _client.dio.post(ApiEndpoints.signUp, data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return AuthUser(
        id: res.data['id'] as String,
        name: name,
        email: email,
        isVerified: false, // OTP step confirms it -- never true right after signup
      );
    } on DioException catch (e) {
      throw _client.mapError(e);
    }
  }

  Future<AuthUser> signIn({required String email, required String password}) async {
    try {
      final res = await _client.dio.post(ApiEndpoints.signIn, data: {
        'email': email,
        'password': password,
      });
      return AuthUser(
        id: res.data['id'] as String,
        name: res.data['name'] as String,
        email: email,
        isVerified: res.data['isVerified'] as bool? ?? true,
        token: res.data['token'] as String?,
      );
    } on DioException catch (e) {
      throw _client.mapError(e);
    }
  }

  Future<AuthUser> verifyOtp({required String email, required String code}) async {
    try {
      final res = await _client.dio.post(ApiEndpoints.verifyOtp, data: {
        'email': email,
        'code': code,
      });
      return AuthUser(
        id: res.data['id'] as String,
        name: res.data['name'] as String,
        email: email,
        isVerified: true,
        token: res.data['token'] as String?,
      );
    } on DioException catch (e) {
      throw _client.mapError(e);
    }
  }

  Future<void> resendOtp({required String email}) async {
    try {
      await _client.dio.post(ApiEndpoints.resendOtp, data: {'email': email});
    } on DioException catch (e) {
      throw _client.mapError(e);
    }
  }

  Future<void> sendPasswordResetCode({required String email}) async {
    try {
      await _client.dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } on DioException catch (e) {
      throw _client.mapError(e);
    }
  }
}
