import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/services/preferences_service.dart';

/// Service for managing app theme
class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final _preferencesService = PreferencesService();
  ThemeMode _themeMode = ThemeMode.dark;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether dark mode is enabled
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize and load saved theme preference
  Future<void> initialize() async {
    await _preferencesService.initialize();
    _themeMode = _preferencesService.preferences.themeMode;
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _preferencesService.setThemeMode(mode);
    notifyListeners();
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
