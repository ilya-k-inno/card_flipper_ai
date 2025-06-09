import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class LocaleManager with ChangeNotifier {
  LocaleManager(this._prefs);

  final SharedPreferences _prefs;
  
  // Current locale
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  
  // Supported locales
  final List<Locale> supportedLocales = const [
    Locale('en'), // English
    Locale('ja'), // Japanese
    Locale('ru'), // Russian
  ];
  
  // Initialize locale from shared preferences or system
  Future<void> initialize() async {
    final languageCode = _prefs.getString(AppConfig.languageCodeKey);
    final countryCode = _prefs.getString(AppConfig.countryCodeKey);
    
    if (languageCode != null) {
      _locale = Locale(languageCode, countryCode);
    } else {
      // Use system locale if available, otherwise default to English
      final systemLocale = WidgetsBinding.instance.window.locale;
      _locale = supportedLocales.contains(systemLocale)
          ? systemLocale
          : const Locale('en');
    }
    
    notifyListeners();
  }
  
  // Set locale
  Future<void> setLocale(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale)) return;
    
    _locale = newLocale;
    await Future.wait([
      _prefs.setString(AppConfig.languageCodeKey, newLocale.languageCode),
      if (newLocale.countryCode != null)
        _prefs.setString(AppConfig.countryCodeKey, newLocale.countryCode!),
    ]);
    
    notifyListeners();
  }
  
  // Get display name of a locale
  String getDisplayName(Locale locale, BuildContext context) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'ru':
        return 'Русский';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
