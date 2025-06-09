import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class ThemeManager with ChangeNotifier {
  ThemeManager(this._prefs);

  final SharedPreferences _prefs;
  
  // Theme mode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  
  // Initialize theme mode from shared preferences
  Future<void> initialize() async {
    final themeModeIndex = _prefs.getInt(AppConfig.themeModeKey);
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values[themeModeIndex];
      notifyListeners();
    }
  }
  
  // Toggle between light, dark, and system theme
  Future<void> toggleTheme() async {
    final newThemeMode = _themeMode == ThemeMode.system
        ? ThemeMode.light
        : _themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.system;
    
    await setThemeMode(newThemeMode);
  }
  
  // Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(AppConfig.themeModeKey, mode.index);
    notifyListeners();
  }
  
  // Check if dark mode is enabled based on current theme mode
  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }
}
