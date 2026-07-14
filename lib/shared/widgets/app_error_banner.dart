import 'package:flutter/material.dart';

/// Inline, form-level error -- shown above the submit button when a
/// request fails (wrong password, server error, etc.). Distinct from
/// AppSnackbar, which is for transient, non-blocking notifications.
class AppErrorBanner extends StatelessWidget {
  const AppErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final errorBg = theme.colorScheme.errorContainer;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: errorBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: errorColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: errorColor, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
