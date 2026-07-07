/// Everything thrown by the network layer funnels into one of these,
/// so repositories and ViewModels only ever need to catch AppException
/// -- never raw DioException, SocketException, FormatException, etc.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException() : super('No internet connection.');
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Session expired. Please sign in again.');
}

class UnknownException extends AppException {
  const UnknownException() : super('Something went wrong. Please try again.');
}
