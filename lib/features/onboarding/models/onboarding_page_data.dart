/// Plain data describing each onboarding page. Kept separate from the
/// widget so the copy is easy to edit without touching layout code.
/// Update `imageAsset` paths to match whatever you named the files you
/// already added to your assets folder.
class OnboardingPageData {
  final String imageAsset;
  final String title;
  final String description;
  final List<String>? badges; // e.g. "BLUETOOTH", "WI-FI DIRECT" tags

  const OnboardingPageData({
    required this.imageAsset,
    required this.title,
    required this.description,
    this.badges,
  });
}

const List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    imageAsset: 'assets/onboarding/connectivity.png',
    title: 'Always Connected, No\nInternet Needed',
    description:
        'Chat reliably with peers nearby using Bluetooth, BLE, and Wi-Fi Direct. '
        'Powered by Google Nearby API for a seamless, offline-first experience.',
    badges: ['BLUETOOTH', 'WI-FI DIRECT'],
  ),
  OnboardingPageData(
    imageAsset: 'assets/onboarding/collaborate.png',
    title: 'Collaborate in Local Rooms',
    description:
        'Create study groups that work anywhere. Share messages, coordinates, '
        'and files within your local mesh network as easily as a standard chat.',
  ),
  OnboardingPageData(
    imageAsset: 'assets/onboarding/shared_notes.png',
    title: 'Powerful Shared Notes',
    description:
        'Write, edit, and collaborate on notes with multiple users in real-time. '
        'Convert Word to PDF instantly and share documents within your mesh chat effortlessly.',
  ),
];
