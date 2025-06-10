import 'package:pixel_flip/src/features/game/data/datasources/game_cache_data_source.dart';
import 'package:pixel_flip/src/features/game/domain/entities/cached_game.dart';
import 'package:pixel_flip/src/features/game/domain/repositories/game_cache_repository.dart';

class GameCacheRepositoryImpl implements GameCacheRepository {
  final GameCacheDataSource dataSource;

  GameCacheRepositoryImpl(this.dataSource);

  @override
  Future<void> cacheGame(CachedGame game) async {
    await dataSource.cacheGame(game.prompt, game.imageUrls);
  }

  @override
  Future<CachedGame?> getLastPlayedGame() async {
    final gameData = await dataSource.getLastPlayedGame();
    if (gameData == null) return null;
    
    try {
      return CachedGame.fromJson(gameData);
    } catch (e) {
      return null;
    }
  }
}
