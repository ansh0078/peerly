import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'network_exceptions.dart';

/// One Dio instance for the whole app. Interceptors here (logging now,
/// auth-token attachment later) apply to every request automatically --
/// no feature repository configures Dio itself.
class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  /// Every data source call should go through this, not dio.post/get
  /// directly -- so a DioException always becomes a typed AppException
  /// that the rest of the app knows how to handle.
  AppException mapError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NoInternetException();
    }
    final status = e.response?.statusCode;
    if (status == 401) return const UnauthorizedException();
    if (status != null && status >= 400 && status < 500) {
      final data = e.response?.data;
      final serverMessage = data is Map ? data['message'] as String? : null;
      return ValidationException(serverMessage ?? 'Invalid request.');
    }
    if (status != null && status >= 500) {
      return const ServerException('Server error. Please try again shortly.');
    }
    return const UnknownException();
  }
}
