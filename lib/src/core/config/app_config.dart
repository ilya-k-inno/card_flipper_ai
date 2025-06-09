import 'package:flutter/material.dart';

/// App configuration constants
class AppConfig {
  // App Info
  static const String appName = 'Pixel Flip';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String pixabayApiKey = 'YOUR_PIXABAY_API_KEY';
  static const String pixabayBaseUrl = 'https://pixabay.com/api/';
  static const int pixabayPerPage = 30;
  
  // Game Configuration
  static const int cardPairsCount = 8; // 8 pairs = 16 cards (4x4 grid)
  static const Duration flipAnimationDuration = Duration(milliseconds: 400);
  static const Duration cardFlipDelay = Duration(milliseconds: 500);
  
  // UI Configuration
  static const double cardAspectRatio = 1.0; // Square cards
  static const double cardBorderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const double buttonHeight = 48.0;
  static const double buttonBorderRadius = 24.0;
  
  // Animation Durations
  static const Duration buttonAnimationDuration = Duration(milliseconds: 200);
  static const Duration dialogAnimationDuration = Duration(milliseconds: 300);
  
  // Local Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String languageCodeKey = 'language_code';
  static const String countryCodeKey = 'country_code';
  
  // Error Messages
  static const String defaultErrorMessage = 'An unexpected error occurred';
  static const String noInternetMessage = 'No internet connection';
  
  // Links
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  
  // Prevent instantiation
  const AppConfig._();
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ja', ''), // Japanese
    Locale('ru', ''), // Russian
  ];
}
