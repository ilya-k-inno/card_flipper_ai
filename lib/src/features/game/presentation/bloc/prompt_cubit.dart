import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/src/core/error/failures.dart';
import 'package:pixel_flip/src/core/network/connectivity_service.dart';
import 'package:pixel_flip/src/features/game/domain/repositories/game_repository.dart';

part 'prompt_state.dart';

class PromptCubit extends Cubit<PromptState> {
  final GameRepository gameRepository;
  final ConnectivityService connectivityService;

  StreamSubscription? _connectivitySubscription;
  bool _isConnected = true;

  PromptCubit({
    required this.gameRepository,
    required this.connectivityService,
  }) : super(const PromptInitial()) {
    // Listen to connectivity changes
    _connectivitySubscription =
        connectivityService.onConnectivityChanged.listen(
      (isConnected) {
        _isConnected = isConnected;
        if (state is PromptLoaded) {
          // Update the state to reflect the new connectivity status
          emit((state as PromptLoaded).copyWith(isOnline: isConnected));
        } else if (state is PromptError) {
          // If we were in an error state, we might want to allow retry
          emit(PromptInitial(isOnline: isConnected));
        } else {
          // For other states, just update the connectivity status
          emit(state.copyWith(isOnline: isConnected));
        }
      },
    );

    // Initial connectivity check
    _checkConnectivity();
  }

  Future<bool> checkConnectivity() async {
    _isConnected = await connectivityService.isConnected;
    if (_isConnected != state.isOnline) {
      emit(state.copyWith(isOnline: _isConnected));
    }
    return _isConnected;
  }

  Future<void> _checkConnectivity() async {
    await checkConnectivity();
  }

  Future<void> searchImages(String query) async {
    if (query.trim().isEmpty) {
      emit(PromptError('Please enter a search term', isOnline: _isConnected));
      return;
    }

    emit(const PromptLoading());

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
        emit(PromptError(
          _mapFailureToMessage(failure),
          isOnline: _isConnected,
        ));
      },
      (imageUrls) {
        if (imageUrls.length < 8) {
          emit(PromptError(
            'Not enough images found. Please try a different search term.',
            isOnline: _isConnected,
          ));
        } else {
          emit(PromptLoaded(
            imageUrls: imageUrls,
            searchQuery: query,
            isOnline: _isConnected,
          ));
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
    emit(const PromptInitial(isOnline: true));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
