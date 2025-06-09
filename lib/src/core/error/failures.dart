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
  const ServerFailure(super.message, {super.stackTrace});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.stackTrace});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.stackTrace});
}

class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure() : super('No internet connection');
}

// Game-specific failures
class GameInitializationFailure extends Failure {
  const GameInitializationFailure(super.message, {super.stackTrace});
}

// API-specific failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.stackTrace});
}

class RateLimitExceededFailure extends Failure {
  const RateLimitExceededFailure(super.message, {super.stackTrace});
}

// Localization failures
class LocalizationFailure extends Failure {
  const LocalizationFailure(super.message, {super.stackTrace});
}
