import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized text styles. Prefer these over inline TextStyle()
/// calls so a typography change is a one-file edit.
class AppTextStyles {
  AppTextStyles._();

  static const label = TextStyle(fontSize: 13, fontWeight: FontWeight.w600);

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const link = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}
