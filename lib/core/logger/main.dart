// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'core/di/injection.dart';
// import 'features/dashboard/presentation/screens/dashboard_screen.dart';

// void main() {
//   setupDependencies(); // GetIt wiring happens once, before anything else
//   runApp(const ProviderScope(child: PeerlyApp()));
// }

// class PeerlyApp extends StatelessWidget {
//   const PeerlyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Peerly',
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4F46E5)),
//       home: const DashboardScreen(userName: 'Sarah'),
//     );
//   }
// }
