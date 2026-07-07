import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerly/app/router/app_route.dart';
import 'package:peerly/app/router/app_route_name.dart';
import 'package:peerly/app/theme/app_theme.dart';
import 'package:peerly/app/theme/theme_mode_provider.dart';
import 'package:peerly/core/di/injection.dart';

void main() {
  setupDependencies(); // GetIt wiring happens once, before anything else
  runApp(const PeerlyApp());
}

class PeerlyApp extends ConsumerWidget {
  const PeerlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: "Peerly",
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: AppRoutesName.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
