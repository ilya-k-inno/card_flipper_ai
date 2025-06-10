part of 'settings_cubit.dart';

abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoaded extends SettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isDarkMode;

  const SettingsLoaded({
    required this.themeMode,
    required this.locale,
    required this.isDarkMode,
  });

  SettingsLoaded copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isDarkMode,
  }) {
    return SettingsLoaded(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);
}
