import 'package:flutter/material.dart';

/// Every color used anywhere in the app should come from here -- never
/// hardcode a hex value directly in a widget. That's what makes light/
/// dark theming (and any future rebrand) a one-file change instead of
/// a find-and-replace across the whole codebase.
class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF4F46E5);
  static const primaryDark = Color(0xFF6366F1);

  // Light theme
  static const lightBackground = Color(0xFFF7F7FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightInputFill = Color(0xFFF3F4F6);

  // Dark theme
  static const darkBackground = Color(0xFF0F0F13);
  static const darkSurface = Color(0xFF1B1B23);
  static const darkInputFill = Color(0xFF24242E);

  // Semantic -- status colors stay the same in both themes
  static const success = Color(0xFF16A34A);
  static const error = Color(0xFFDC2626);
  static const errorBackground = Color(0xFFFEE2E2);
  static const warning = Color(0xFFD97706);
  static const warningBackground = Color(0xFFFFF7E6);

  // Snackbar surfaces -- deliberately fixed dark/amber regardless of
  // app theme, matching the reference design.
  static const snackbarDarkBg = Color(0xFF111113);
}
