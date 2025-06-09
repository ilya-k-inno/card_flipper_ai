part of 'prompt_cubit.dart';

abstract class PromptState extends Equatable {
  final bool isOnline;

  const PromptState({this.isOnline = true});

  PromptState copyWith({bool? isOnline});

  @override
  List<Object> get props => [isOnline];
}

class PromptInitial extends PromptState {
  const PromptInitial({super.isOnline = true});

  @override
  PromptInitial copyWith({bool? isOnline}) {
    return PromptInitial(
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class PromptLoading extends PromptState {
  const PromptLoading({super.isOnline = true});

  @override
  PromptLoading copyWith({bool? isOnline}) {
    return PromptLoading(
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class PromptLoaded extends PromptState {
  final List<String> imageUrls;
  final String searchQuery;

  const PromptLoaded({
    required this.imageUrls,
    required this.searchQuery,
    super.isOnline = true,
  });

  @override
  List<Object> get props => [imageUrls, searchQuery, isOnline];

  @override
  PromptLoaded copyWith({
    List<String>? imageUrls,
    String? searchQuery,
    bool? isOnline,
  }) {
    return PromptLoaded(
      imageUrls: imageUrls ?? this.imageUrls,
      searchQuery: searchQuery ?? this.searchQuery,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class PromptError extends PromptState {
  final String message;

  const PromptError(this.message, {super.isOnline = true});

  @override
  List<Object> get props => [message, isOnline];

  @override
  PromptError copyWith({
    String? message,
    bool? isOnline,
  }) {
    return PromptError(
      message ?? this.message,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
