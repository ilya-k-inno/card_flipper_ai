part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameInProgress extends GameState {
  final List<CardModel> cards;
  final int moves;
  final int matches;
  final List<String>? imageUrls;
  final bool isOfflineMode;

  const GameInProgress({
    required this.cards,
    this.moves = 0,
    this.matches = 0,
    this.imageUrls,
    this.isOfflineMode = false,
  });

  GameInProgress copyWith({
    List<CardModel>? cards,
    int? moves,
    int? matches,
    List<String>? imageUrls,
    bool? isOfflineMode,
  }) {
    return GameInProgress(
      cards: cards ?? this.cards,
      moves: moves ?? this.moves,
      matches: matches ?? this.matches,
      imageUrls: imageUrls ?? this.imageUrls,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }

  @override
  List<Object?> get props => [cards, moves, matches, imageUrls, isOfflineMode];
}

class GameWon extends GameInProgress {
  const GameWon({
    required super.cards,
    required super.moves,
    required super.matches,
    super.imageUrls,
    super.isOfflineMode,
  });
}

class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object> get props => [message];
}
