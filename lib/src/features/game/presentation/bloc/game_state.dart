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

  const GameInProgress({
    required this.cards,
    this.moves = 0,
    this.matches = 0,
  });

  GameInProgress copyWith({
    List<CardModel>? cards,
    int? moves,
    int? matches,
  }) {
    return GameInProgress(
      cards: cards ?? this.cards,
      moves: moves ?? this.moves,
      matches: matches ?? this.matches,
    );
  }

  @override
  List<Object?> get props => [cards, moves, matches];
}

class GameWon extends GameInProgress {
  const GameWon({
    required super.cards,
    required super.moves,
    required super.matches,
  });
}

class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object> get props => [message];
}
