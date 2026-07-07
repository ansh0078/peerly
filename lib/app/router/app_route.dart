import 'package:flutter/material.dart';
import 'package:peerly/app/router/app_route_name.dart';
import 'package:peerly/features/auth/presentation/screens/device_permissions_screen.dart';
import 'package:peerly/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:peerly/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:peerly/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:peerly/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:peerly/features/auth/presentation/screens/welcome_screen.dart';
import 'package:peerly/features/auth/presentation/widgets/verification_reminder_listener.dart';
import 'package:peerly/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:peerly/features/onboarding/screens/onboarding_screen.dart';
import 'package:peerly/features/splash/presentation/screens/splash_screen.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutesName.splash: (context) => SplashScreen(
            onNavigateToOnboarding: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.onboarding),
            onNavigateToWelcome: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.welcome),
            onNavigateToHome: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.home),
          ),

      AppRoutesName.onboarding : (context) => OnboardingScreen(
            onFinished: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.welcome),
          ),

      AppRoutesName.welcome : (context) => WelcomeScreen(
            onCreateAccount: () =>
                Navigator.of(context).pushNamed(AppRoutesName.signup),
            onSignIn: () =>
                Navigator.of(context).pushNamed(AppRoutesName.signin),
          ),

      AppRoutesName.signup: (context) => SignUpScreen(
            onSignIn: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.signin),

            // Offline signup skips OTP.
            onSignedUpOffline: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.permissions),

            // Online signup requires OTP.
            onSignedUpOnline: (email) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OtpVerificationScreen(
                    email: email,
                    onVerified: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutesName.permissions);
                    },
                  ),
                ),
              );
            },
          ),

      AppRoutesName.signin: (context) => SignInScreen(
            onSignedIn: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.permissions),
            onForgotPassword: () =>
                Navigator.of(context).pushNamed(AppRoutesName.forgetPwd),
            onCreateAccount: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.signup),
          ),

      AppRoutesName.forgetPwd : (context) => ForgotPasswordScreen(
            onBackToSignIn: () => Navigator.of(context).pop(),
          ),

      AppRoutesName.permissions : (context) => DevicePermissionsScreen(
            onContinue: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.home),
          ),

      AppRoutesName.home : (context) =>
          const VerificationReminderListener(
            child: DashboardScreen(),
          ),
    };
  }
}