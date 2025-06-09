import 'package:flutter/material.dart';

/// Interface for settings repository that handles theme and locale settings
abstract class SettingsRepository {
  /// Get current theme mode
  ThemeMode getThemeMode();
  
  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode);
  
  /// Stream of theme mode changes
  Stream<ThemeMode> get themeModeChanges;
  
  /// Get current locale
  Locale getLocale();
  
  /// Set locale
  Future<void> setLocale(Locale locale);
  
  /// Stream of locale changes
  Stream<Locale> get localeChanges;
  
  /// Dispose resources
  Future<void> dispose();
}
