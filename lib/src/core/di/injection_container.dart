import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../src/core/network/connectivity_service.dart';
import '../../../src/features/game/data/datasources/pixabay_datasource.dart';
import '../../../src/features/game/data/repositories/game_repository_impl.dart';
import '../../../src/features/game/domain/repositories/game_repository.dart';
import '../../../src/features/game/presentation/bloc/game_cubit.dart';
import '../../../src/features/game/presentation/bloc/prompt_cubit.dart';
import '../../../src/features/settings/data/repositories/settings_repository_impl.dart';
import '../../../src/features/settings/domain/repositories/settings_repository.dart';
import '../../../src/features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Services
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(),
  );
  
  // Data sources
  sl.registerLazySingleton<PixabayDataSource>(
    () => PixabayDataSourceImpl(client: sl()),
  );
  
  // Repository
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  
  // Settings
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  
  sl.registerLazySingleton(
    () => SettingsCubit(sl()),
  );
  
  // BLoCs / Cubits
  sl.registerFactory(
    () => PromptCubit(
      gameRepository: sl(),
      connectivityService: sl(),
    ),
  );
  
  sl.registerFactory(
    () => GameCubit(),
  );
}
