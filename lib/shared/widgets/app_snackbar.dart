import 'package:flutter/material.dart';
import 'package:peerly/app/theme/app_colors.dart';

/// The ONE place SnackBars get built. Call AppSnackbar.success(context, ...),
/// .warning(...), or .error(...) from anywhere -- never construct a
/// SnackBar inline in a screen, or the "pop after success" style will
/// drift between screens over time.
class AppSnackbar {
  AppSnackbar._();

  static void success(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
    _show(
      context,
      backgroundColor: AppColors.snackbarDarkBg,
      icon: Icons.check_circle,
      iconColor: AppColors.success,
      textColor: Colors.white,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      backgroundColor: AppColors.snackbarDarkBg,
      icon: Icons.error,
      iconColor: AppColors.error,
      textColor: Colors.white,
      message: message,
    );
  }

  /// Amber, non-blocking banner -- used for things like the deferred
  /// email-verification nudge ("You're back online -- verify now?").
  static void warning(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
    _show(
      context,
      backgroundColor: AppColors.warningBackground,
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.warning,
      textColor: AppColors.warning,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      border: Border.all(color: AppColors.warning.withOpacity(0.3)),
    );
  }

  static void _show(
    BuildContext context, {
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Border? border,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: border,
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(message, style: TextStyle(color: textColor, fontSize: 13))),
              if (actionLabel != null)
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onAction?.call();
                  },
                  child: Text(actionLabel, style: const TextStyle(color: Color(0xFF60A5FA))),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
