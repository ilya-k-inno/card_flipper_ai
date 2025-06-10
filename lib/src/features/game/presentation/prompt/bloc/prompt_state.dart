part of 'prompt_cubit.dart';

abstract class PromptState {
  final bool isOnline;
  final CachedGame? cachedGame;

  const PromptState({
    this.isOnline = true,
    this.cachedGame,
  });

  PromptState copyWith({
    bool? isOnline,
    CachedGame? cachedGame,
  });
}

class PromptInitial extends PromptState {
  const PromptInitial({
    super.isOnline = true,
    super.cachedGame,
  });

  @override
  PromptInitial copyWith({
    bool? isOnline,
    CachedGame? cachedGame,
  }) {
    return PromptInitial(
      isOnline: isOnline ?? this.isOnline,
      cachedGame: cachedGame ?? this.cachedGame,
    );
  }
}

class PromptLoading extends PromptState {
  const PromptLoading({
    super.isOnline = true,
    super.cachedGame,
  });

  @override
  PromptLoading copyWith({
    bool? isOnline,
    CachedGame? cachedGame,
  }) {
    return PromptLoading(
      isOnline: isOnline ?? this.isOnline,
      cachedGame: cachedGame ?? this.cachedGame,
    );
  }
}

class PromptLoaded extends PromptState {
  final List<String> imageUrls;
  final String? searchQuery;

  const PromptLoaded({
    required this.imageUrls,
    super.isOnline = true,
    this.searchQuery,
    super.cachedGame,
  });

  @override
  PromptLoaded copyWith({
    List<String>? imageUrls,
    bool? isOnline,
    String? searchQuery,
    CachedGame? cachedGame,
  }) {
    return PromptLoaded(
      imageUrls: imageUrls ?? this.imageUrls,
      isOnline: isOnline ?? this.isOnline,
      searchQuery: searchQuery ?? this.searchQuery,
      cachedGame: cachedGame ?? this.cachedGame,
    );
  }
}

class PromptError extends PromptState {
  final String message;

  const PromptError(
    this.message, {
    super.isOnline = true,
    super.cachedGame,
  });

  @override
  PromptError copyWith({
    String? message,
    bool? isOnline,
    CachedGame? cachedGame,
  }) {
    return PromptError(
      message ?? this.message,
      isOnline: isOnline ?? this.isOnline,
      cachedGame: cachedGame ?? this.cachedGame,
    );
  }
}
