import 'package:flutter/material.dart';

class OnboardingDotIndicator extends StatelessWidget {
  const OnboardingDotIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4F46E5) : const Color(0xFFD9D9E3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
