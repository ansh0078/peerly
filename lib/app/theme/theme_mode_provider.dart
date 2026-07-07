import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Defaults to ThemeMode.system -- the app follows the device's light/
/// dark setting until the user overrides it from Settings, e.g.:
/// ref.read(themeModeProvider.notifier).state = ThemeMode.dark
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
