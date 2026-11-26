import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance. Overridden in main().
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in ProviderScope');
});

/// Key used to persist theme mode in SharedPreferences.
const String _kThemeModeKey = 'app_theme_mode';

/// Riverpod 3.0 Notifier managing ThemeMode with persistent storage.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    try {
      final prefs = ref.watch(sharedPreferencesProvider);
      final saved = prefs.getString(_kThemeModeKey);
      switch (saved) {
        case 'dark':
          return ThemeMode.dark;
        case 'light':
          return ThemeMode.light;
        case 'system':
          return ThemeMode.system;
        default:
          return ThemeMode.light;
      }
    } catch (_) {
      // Graceful fallback for unit tests or before prefs is injected
      return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      String value;
      switch (mode) {
        case ThemeMode.dark:
          value = 'dark';
          break;
        case ThemeMode.light:
          value = 'light';
          break;
        case ThemeMode.system:
          value = 'system';
          break;
      }
      await prefs.setString(_kThemeModeKey, value);
    } catch (_) {
      // Ignored in test environment
    }
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}

/// Provider for current ThemeMode across the entire application.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
