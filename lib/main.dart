import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'src/core/config/app_config.dart';
import 'src/core/di/injection_container.dart' as di;
import 'src/core/theme/app_theme.dart';
import 'src/features/game/presentation/bloc/game_cubit.dart';
import 'src/features/game/presentation/bloc/prompt_cubit.dart';
import 'src/features/game/presentation/pages/game_screen.dart';
import 'src/features/game/presentation/pages/prompt_screen.dart';
import 'src/features/settings/data/repositories/settings_repository_impl.dart';
import 'src/features/settings/domain/repositories/settings_repository.dart';
import 'src/features/settings/presentation/cubit/settings_cubit.dart';
import 'src/features/settings/presentation/pages/settings_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();

  // Create settings repository
  final settingsRepository = SettingsRepositoryImpl(prefs);

  // Initialize settings cubit
  final settingsCubit = SettingsCubit(settingsRepository);
  await settingsCubit.initialize();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsRepository>.value(
          value: settingsRepository,
        ),
      ],
      child: PixelFlipApp(settingsCubit: settingsCubit),
    ),
  );
}

class PixelFlipApp extends StatelessWidget {
  final SettingsCubit settingsCubit;

  const PixelFlipApp({
    super.key,
    required this.settingsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Game-related providers
        BlocProvider(create: (_) => di.sl<PromptCubit>()),
        BlocProvider(create: (_) => di.sl<GameCubit>()),

        // Settings provider
        BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final isDarkMode = settingsState is SettingsLoaded
              ? settingsState.isDarkMode
              : Theme.of(context).brightness == Brightness.dark;

          final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

          return MaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: theme,
            themeMode: settingsState is SettingsLoaded
                ? settingsState.themeMode
                : ThemeMode.system,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ja', ''), // Japanese
              Locale('ru', ''), // Russian
            ],
            locale:
                settingsState is SettingsLoaded ? settingsState.locale : null,
            home: const PromptScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/game':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => GameScreen(
                      imageUrls: args['imageUrls'] as List<String>?,
                      isOfflineMode: args['isOfflineMode'] as bool? ?? false,
                    ),
                  );
                case '/':
                  return MaterialPageRoute(
                    builder: (_) => const PromptScreen(),
                  );
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
