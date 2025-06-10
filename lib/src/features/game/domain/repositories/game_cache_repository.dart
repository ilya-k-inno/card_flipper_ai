import 'package:pixel_flip/src/features/game/domain/entities/cached_game.dart';

abstract class GameCacheRepository {
  Future<void> cacheGame(CachedGame game);
  Future<CachedGame?> getLastPlayedGame();
}
