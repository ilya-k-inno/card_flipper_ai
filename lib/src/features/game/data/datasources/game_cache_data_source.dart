import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixel_flip/src/features/game/domain/entities/cached_game.dart';

abstract class GameCacheDataSource {
  Future<void> cacheGame(String prompt, List<String> imageUrls);
  Future<Map<String, dynamic>?> getLastPlayedGame();
}

class GameCacheDataSourceImpl implements GameCacheDataSource {
  static const String _cachedGameKey = 'last_played_game';
  final SharedPreferences _prefs;

  GameCacheDataSourceImpl(this._prefs);

  @override
  Future<void> cacheGame(String prompt, List<String> imageUrls) async {
    final game = CachedGame(
      prompt: prompt,
      imageUrls: imageUrls,
    ).toJson();
    
    await _prefs.setString(_cachedGameKey, jsonEncode(game));
  }

  @override
  Future<Map<String, dynamic>?> getLastPlayedGame() async {
    final gameJson = _prefs.getString(_cachedGameKey);
    if (gameJson == null) return null;
    
    try {
      return jsonDecode(gameJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
