import 'package:flutter/material.dart';

/// App configuration constants
class AppConfig {
  // App Info
  static const String appName = 'Pixel Flip';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String pixabayBaseUrl = 'https://pixabay.com/api/';

  // Local Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String languageCodeKey = 'language_code';
  static const String countryCodeKey = 'country_code';

  // Error Messages
  static const String defaultErrorMessage = 'An unexpected error occurred';
  static const String noInternetMessage = 'No internet connection';

  // Prevent instantiation
  const AppConfig._();

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ja', ''), // Japanese
    Locale('ru', ''), // Russian
  ];
}
