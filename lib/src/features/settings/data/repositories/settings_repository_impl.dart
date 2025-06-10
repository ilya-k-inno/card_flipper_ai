import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;
  final _themeModeController = StreamController<ThemeMode>();
  final _localeController = StreamController<Locale>();

  @override
  ThemeMode getThemeMode() {
    final index = _prefs.getInt(AppConfig.themeModeKey);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(AppConfig.themeModeKey, mode.index);
    _themeModeController.add(mode);
  }

  @override
  Stream<ThemeMode> get themeModeChanges => _themeModeController.stream;

  @override
  Locale getLocale() {
    final languageCode = _prefs.getString(AppConfig.languageCodeKey);
    final countryCode = _prefs.getString(AppConfig.countryCodeKey);

    if (languageCode != null) {
      return Locale(languageCode, countryCode);
    }

    return PlatformDispatcher.instance.locale;
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await Future.wait([
      _prefs.setString(AppConfig.languageCodeKey, locale.languageCode),
      if (locale.countryCode != null)
        _prefs.setString(AppConfig.countryCodeKey, locale.countryCode!),
    ]);

    _localeController.add(locale);
  }

  @override
  Stream<Locale> get localeChanges => _localeController.stream;

  @override
  Future<void> dispose() async {
    await _themeModeController.close();
    await _localeController.close();
  }
}
