class CachedGame {
  final String prompt;
  final List<String> imageUrls;
  final DateTime lastPlayed;

  CachedGame({
    required this.prompt,
    required this.imageUrls,
    DateTime? lastPlayed,
  }) : lastPlayed = lastPlayed ?? DateTime.now();

  factory CachedGame.fromJson(Map<String, dynamic> json) {
    return CachedGame(
      prompt: json['prompt'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      lastPlayed: DateTime.parse(json['lastPlayed'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'imageUrls': imageUrls,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }
}
