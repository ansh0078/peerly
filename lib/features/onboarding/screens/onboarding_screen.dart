import 'package:flutter/material.dart';
import 'package:peerly/core/database/onboarding_status_service.dart';
import '../../../../core/di/injection.dart';
import '../models/onboarding_page_data.dart';
import '../widgets/onboarding_page_view.dart';
import '../widgets/onboarding_dot_indicator.dart';

/// Local UI state only (which page is showing) -- this does NOT need
/// Riverpod. Not every screen needs a ViewModel; a plain StatefulWidget
/// is the right tool when nothing outside this screen cares about the
/// state.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  /// Called after the user finishes or skips onboarding. This screen
  /// doesn't decide what comes next -- main.dart routes this to
  /// Welcome (the auth entry point), not straight into the app.
  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == onboardingPages.length - 1;

  Future<void> _complete() async {
    await getIt<OnboardingStatusService>().markOnboardingComplete();
    widget.onFinished();
  }

  void _next() {
    if (_isLastPage) {
      _complete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 8),
                child: TextButton(
                  onPressed: _complete,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) =>
                    OnboardingPageView(data: onboardingPages[index]),
              ),
            ),
            OnboardingDotIndicator(
              pageCount: onboardingPages.length,
              currentPage: _currentPage,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLastPage ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
