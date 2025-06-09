import 'package:dartz/dartz.dart';
import 'package:pixel_flip/src/core/error/failures.dart';

abstract class GameRepository {
  /// Fetches image URLs based on the search query
  /// Returns a list of image URLs or a Failure
  Future<Either<Failure, List<String>>> searchImages(String query);
  
  /// Generates a list of card values for offline mode
  /// Returns a list of card values (numbers)
  List<String> generateOfflineCards();
}
