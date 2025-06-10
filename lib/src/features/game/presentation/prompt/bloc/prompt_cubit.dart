import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/src/core/error/failures.dart';
import 'package:pixel_flip/src/core/network/connectivity_service.dart';
import 'package:pixel_flip/src/features/game/domain/entities/cached_game.dart';
import 'package:pixel_flip/src/features/game/domain/repositories/game_cache_repository.dart';
import 'package:pixel_flip/src/features/game/domain/repositories/game_repository.dart';

part 'prompt_state.dart';

class PromptCubit extends Cubit<PromptState> {
  final GameRepository gameRepository;
  final ConnectivityService connectivityService;
  final GameCacheRepository cacheRepository;

  StreamSubscription? _connectivitySubscription;
  bool _isConnected = true;

  PromptCubit({
    required this.gameRepository,
    required this.connectivityService,
    required this.cacheRepository,
  }) : super(const PromptInitial()) {
    // Load cached game on initialization
    _loadCachedGame();

    // Listen to connectivity changes
    _connectivitySubscription =
        connectivityService.onConnectivityChanged.listen(
      (isConnected) {
        _isConnected = isConnected;
        emit(state.copyWith(isOnline: isConnected));
      },
    );

    // Initial connectivity check
    checkConnectivity();
  }

  Future<bool> checkConnectivity() async {
    _isConnected = await connectivityService.isConnected;
    if (_isConnected != state.isOnline) {
      emit(state.copyWith(isOnline: _isConnected));
    }
    return _isConnected;
  }

  Future<void> _loadCachedGame() async {
    final cachedGame = await cacheRepository.getLastPlayedGame();
    emit(state.copyWith(cachedGame: cachedGame));
  }

  Future<void> cacheGame(CachedGame game) async {
    await cacheRepository.cacheGame(game);
    emit(state.copyWith(
      cachedGame: game,
    ));
  }

  void playCachedGame() {
    if (state.cachedGame != null) {
      emit(
        PromptLoaded(
          imageUrls: state.cachedGame!.imageUrls,
          isOnline: _isConnected,
          searchQuery: state.cachedGame!.prompt,
          cachedGame: state.cachedGame,
        ),
      );
    } else {
      // If cached game is not available, emit current state with hasCachedGame false
      emit(
        PromptError(
          'Cached game not found',
          isOnline: _isConnected,
        ),
      );
    }
  }

  Future<void> searchImages(String query) async {
    if (query.trim().isEmpty) {
      emit(
        PromptError(
          'Please enter a search term',
          isOnline: _isConnected,
        ),
      );
      return;
    }

    emit(
      PromptLoading(
        cachedGame: state.cachedGame,
      ),
    );

    if (!_isConnected) {
      emit(
        const PromptError(
          'No internet connection. Please check your connection and try again.',
          isOnline: false,
        ),
      );
      return;
    }

    final result = await gameRepository.searchImages(query);

    result.fold(
      (failure) {
        emit(
          PromptError(
            _mapFailureToMessage(failure),
            isOnline: _isConnected,
          ),
        );
      },
      (imageUrls) async {
        if (imageUrls.length < 8) {
          emit(
            PromptError(
              'Not enough images found. Please try a different search term.',
              isOnline: _isConnected,
            ),
          );
        } else {
          // Cache the game before emitting loaded state
          final cachedGame = CachedGame(
            prompt: query,
            imageUrls: imageUrls,
          );
          await cacheGame(cachedGame);
          emit(
            PromptLoaded(
              imageUrls: imageUrls,
              isOnline: _isConnected,
              searchQuery: query,
              cachedGame: cachedGame,
            ),
          );
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NoInternetFailure) {
      return 'No internet connection. Please check your connection and try again.';
    } else if (failure is ServerFailure) {
      return 'Server error: ${failure.message}';
    } else if (failure is NetworkFailure) {
      return 'Network error: ${failure.message}';
    } else if (failure is RateLimitExceededFailure) {
      return 'API rate limit exceeded. Please try again later.';
    } else if (failure is UnauthorizedFailure) {
      return 'Authentication error. Please check your API key.';
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  void reset() {
    emit(PromptInitial(isOnline: _isConnected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
