import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Define a state provider to define the hold the app theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeStateNotifier, ThemeMode>(
  (ref) => ThemeModeStateNotifier(),
);

/// Theme mode notifier to use in riverpod provider
class ThemeModeStateNotifier extends StateNotifier<ThemeMode> {
  /// constructor to define default state
  ThemeModeStateNotifier() : super(ThemeMode.system);

  /// Set dark theme in the app
  Future<void> setDarkMode() async {
    // TODO(theTello): Set database to hold theme data
    /// Set theme state
    state = ThemeMode.dark;
  }

  /// Set light theme in the app
  Future<void> setLightMode() async {
    // TODO(theTello): Set database to hold theme data
    /// Set theme state
    state = ThemeMode.light;
  }

  /// Set dark theme in the app
  Future<void> setSystemDefaults() async {
    // TODO(theTello): Set database to hold theme data
    /// Set theme state
    state = ThemeMode.system;
  }
}
