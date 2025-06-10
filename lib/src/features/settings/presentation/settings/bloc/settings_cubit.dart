import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._settingsRepository) : super(const SettingsInitial());

  final SettingsRepository _settingsRepository;
  StreamSubscription<ThemeMode>? _themeModeSubscription;
  StreamSubscription<Locale>? _localeSubscription;

  /// Initialize the cubit by loading the current settings
  Future<void> initialize() async {
    await _initialize();
  }

  Future<void> _initialize() async {
    // Set initial state
    final themeMode = _settingsRepository.getThemeMode();
    final locale = _settingsRepository.getLocale();

    emit(SettingsLoaded(
      themeMode: themeMode,
      locale: locale,
      isDarkMode: _isDarkMode(themeMode),
    ));

    // Listen for changes
    _themeModeSubscription =
        _settingsRepository.themeModeChanges.listen((mode) {
      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(
          themeMode: mode,
          isDarkMode: _isDarkMode(mode),
        ));
      }
    });

    _localeSubscription = _settingsRepository.localeChanges.listen((locale) {
      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(locale: locale));
      }
    });
  }

  bool _isDarkMode(ThemeMode mode, [BuildContext? context]) {
    switch (mode) {
      case ThemeMode.system:
        final brightness = context != null
            ? MediaQuery.of(context).platformBrightness
            : PlatformDispatcher.instance.platformBrightness;
        return brightness == Brightness.dark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }

  Future<void> toggleTheme() async {
    if (state is! SettingsLoaded) return;

    final currentState = state as SettingsLoaded;
    final newThemeMode = currentState.themeMode == ThemeMode.system
        ? ThemeMode.light
        : currentState.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.system;

    await setThemeMode(newThemeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state is! SettingsLoaded) return;

    await _settingsRepository.setThemeMode(mode);
    // State will be updated via the stream subscription
  }

  Future<void> setLocale(Locale locale) async {
    if (state is! SettingsLoaded) return;

    await _settingsRepository.setLocale(locale);
    // State will be updated via the stream subscription
  }

  @override
  Future<void> close() async {
    await _themeModeSubscription?.cancel();
    await _localeSubscription?.cancel();
    await _settingsRepository.dispose();
    super.close();
  }
}
