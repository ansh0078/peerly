import 'package:flutter/material.dart';

/// Swap the Icon()s passed in for real brand logos (e.g. via
/// font_awesome_flutter or your own SVG assets) when you're ready --
/// left generic here since brand-mark usage has its own guidelines.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({super.key, required this.label, required this.icon, this.onPressed});

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, const SizedBox(width: 8), Text(label)],
      ),
    );
  }
}
