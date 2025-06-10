import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/src/features/game/domain/entities/card_model.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  static const int gridSize = 4;
  static const int totalPairs = 8;

  Timer? _flipBackTimer;

  GameCubit() : super(const GameInitial());

  void initializeGame(List<String>? imageUrls,
      {bool isOfflineMode = false}) async {
    emit(const GameLoading());

    try {
      List<CardModel> cards;

      if (isOfflineMode || imageUrls == null || imageUrls.length < totalPairs) {
        // Generate offline cards with numbers 1-8
        cards = _generateNumberCards();
      } else {
        // Use provided image URLs
        cards = _generateImageCards(imageUrls);
      }

      // Shuffle the cards
      cards.shuffle();

      emit(GameInProgress(
        cards: cards,
        moves: 0,
        matches: 0,
        imageUrls: isOfflineMode ? null : imageUrls,
        isOfflineMode: isOfflineMode,
      ));
    } catch (e) {
      emit(GameError('Failed to initialize game: $e'));
    }
  }

  List<CardModel> _generateNumberCards() {
    final List<CardModel> cards = [];

    for (int i = 1; i <= totalPairs; i++) {
      // Add two cards with the same number
      cards.add(CardModel(
        id: 'number_${i}_1',
        value: i.toString(),
      ));

      cards.add(CardModel(
        id: 'number_${i}_2',
        value: i.toString(),
      ));
    }

    return cards;
  }

  List<CardModel> _generateImageCards(List<String> imageUrls) {
    final List<CardModel> cards = [];

    // Take up to totalPairs unique images
    final uniqueImages = imageUrls.toSet().take(totalPairs).toList();

    // If we don't have enough unique images, fill the rest with numbers
    if (uniqueImages.length < totalPairs) {
      final numberNeeded = totalPairs - uniqueImages.length;
      for (int i = 1; i <= numberNeeded; i++) {
        uniqueImages.add('number_$i');
      }
    }

    // Create pairs of cards
    for (int i = 0; i < uniqueImages.length; i++) {
      final url = uniqueImages[i];
      final isNumber = url.startsWith('number_');

      cards.add(CardModel(
        id: '${isNumber ? 'number' : 'image'}_${i}_1',
        value: isNumber ? url.replaceFirst('number_', '') : 'Image ${i + 1}',
        imageUrl: isNumber ? null : url,
      ));

      cards.add(CardModel(
        id: '${isNumber ? 'number' : 'image'}_${i}_2',
        value: isNumber ? url.replaceFirst('number_', '') : 'Image ${i + 1}',
        imageUrl: isNumber ? null : url,
      ));
    }

    return cards;
  }

  void cardTapped(int index) {
    final currentState = state;
    if (currentState is! GameInProgress) return;

    final card = currentState.cards[index];

    // Ignore if the card is already face up, matched, or if we're already processing a pair
    if (card.isFaceUp || card.isMatched || _flipBackTimer != null) {
      return;
    }

    // Get the currently face-up cards that aren't matched yet
    final faceUpCards =
        currentState.cards.where((c) => c.isFaceUp && !c.isMatched).toList();

    // If there are already two face-up cards, ignore the tap
    if (faceUpCards.length >= 2) {
      return;
    }

    // Flip the tapped card
    final updatedCards = List<CardModel>.from(currentState.cards);
    updatedCards[index] = card.copyWith(isFaceUp: true);

    // Check if we have a match
    if (faceUpCards.length == 1) {
      final otherCard = faceUpCards.first;
      final isMatch = otherCard.value == card.value;
      final moves = currentState.moves + 1;

      // Update state to show both cards face up immediately
      emit(currentState.copyWith(
        cards: updatedCards,
        moves: moves,
      ));

      if (isMatch) {
        // Shorter delay before showing the checkmark (reduced from 800ms to 400ms)
        _flipBackTimer = Timer(const Duration(milliseconds: 400), () {
          if (_flipBackTimer == null) return; // Already handled
          _flipBackTimer = null;
          
          if (state is! GameInProgress) return;
          
          final currentState = state as GameInProgress;
          final updatedCards = List<CardModel>.from(currentState.cards);
          bool updated = false;
          
          // Mark all matching cards as matched
          for (int i = 0; i < updatedCards.length; i++) {
            if (updatedCards[i].value == card.value && 
                updatedCards[i].isFaceUp && 
                !updatedCards[i].isMatched) {
              updatedCards[i] = updatedCards[i].copyWith(isMatched: true);
              updated = true;
            }
          }

          if (!updated) return;

          final newMatches = currentState.matches + 1;

          // Check for win condition
          if (newMatches == totalPairs) {
            emit(GameWon(
              cards: updatedCards,
              moves: moves,
              matches: newMatches,
              imageUrls: currentState.imageUrls,
              isOfflineMode: currentState.isOfflineMode,
            ));
          } else {
            emit(currentState.copyWith(
              cards: updatedCards,
              moves: moves,
              matches: newMatches,
            ));
          }
        });
      } else {
        // No match, flip both cards back after a shorter delay
        _flipBackTimer = Timer(const Duration(milliseconds: 800), () {
          if (_flipBackTimer == null) return; // Already handled
          _flipBackTimer = null;
          
          if (state is! GameInProgress) return;
          
          final currentState = state as GameInProgress;
          final resetCards = List<CardModel>.from(currentState.cards);
          bool updated = false;
          
          for (int i = 0; i < resetCards.length; i++) {
            if (resetCards[i].isFaceUp && !resetCards[i].isMatched) {
              resetCards[i] = resetCards[i].copyWith(isFaceUp: false);
              updated = true;
            }
          }
          
          if (updated) {
            emit(currentState.copyWith(cards: resetCards));
          }
        });
      }
    } else {
      // First card flipped, just update the state
      emit(currentState.copyWith(cards: updatedCards));
    }
  }

  void resetGame() {
    _flipBackTimer?.cancel();
    _flipBackTimer = null;

    final currentState = state;
    if (currentState is GameInProgress) {
      // Use the stored offline mode and image URLs from the current state
      if (currentState.isOfflineMode) {
        initializeGame(null, isOfflineMode: true);
      } else {
        initializeGame(currentState.imageUrls, isOfflineMode: false);
      }
    } else {
      emit(const GameInitial());
    }
  }

  @override
  Future<void> close() {
    _flipBackTimer?.cancel();
    return super.close();
  }
}
