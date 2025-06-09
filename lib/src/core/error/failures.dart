import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];

  @override
  String toString() => 'Failure: $message';
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(String message, {StackTrace? stackTrace}) 
      : super(message, stackTrace: stackTrace);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {StackTrace? stackTrace}) 
      : super(message, stackTrace: stackTrace);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, {StackTrace? stackTrace}) 
      : super(message, stackTrace: stackTrace);
}

class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure() : super('No internet connection');
}

// Game-specific failures
class GameInitializationFailure extends Failure {
  const GameInitializationFailure(String message, {StackTrace? stackTrace}) 
      : super(message, stackTrace: stackTrace);
}

// API-specific failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message, {StackTrace? stackTrace}) 
      : super(message, stackTrace: stackTrace);
}

class RateLimitExceededFailure extends Failure {
  const RateLimitExceededFailure(String message, {StackTrace? stackTrace}) 
      : super(message, stackTrace: stackTrace);
}

// Localization failures
class LocalizationFailure extends Failure {
  const LocalizationFailure(String message, {StackTrace? stackTrace}) 
      : super(message, stackTrace: stackTrace);
}
