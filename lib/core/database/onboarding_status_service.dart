import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences for the one non-sensitive flag onboarding
/// needs. Nothing else in the app should call SharedPreferences
/// directly -- go through a service like this one, so if the storage
/// mechanism ever changes, only this file needs to.
class OnboardingStatusService {
  static const _key = 'has_seen_onboarding';

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
