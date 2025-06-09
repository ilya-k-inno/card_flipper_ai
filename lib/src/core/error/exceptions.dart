// Base exception class
class AppException implements Exception {
  final String message;
  
  const AppException(this.message);
  
  @override
  String toString() => message;
}

// Server-related exceptions
class ServerException extends AppException {
  const ServerException(String message) : super(message);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
}

// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class NoInternetException extends NetworkException {
  const NoInternetException() : super('No internet connection');
}

// API-specific exceptions
class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message);
}

class RateLimitExceededException extends AppException {
  const RateLimitExceededException(String message) : super(message);
}

// Game-specific exceptions
class GameInitializationException extends AppException {
  const GameInitializationException(String message) : super(message);
}

// Localization exceptions
class LocalizationException extends AppException {
  const LocalizationException(String message) : super(message);
}
