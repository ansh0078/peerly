/// Change [baseUrl] to your actual Node/Express backend once deployed.
class ApiEndpoints {
  ApiEndpoints._();

  static const baseUrl = 'https://api.peerly.example.com';

  static const signUp = '/auth/signup';
  static const signIn = '/auth/login';
  static const verifyOtp = '/auth/verify-otp';
  static const resendOtp = '/auth/resend-otp';
  static const forgotPassword = '/auth/forgot-password';
}
