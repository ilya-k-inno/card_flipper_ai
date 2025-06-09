import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:pixel_flip/src/core/error/exceptions.dart';
import 'package:pixel_flip/src/core/error/failures.dart';
import 'package:pixel_flip/src/features/game/data/datasources/pixabay_datasource.dart';
import 'package:pixel_flip/src/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final PixabayDataSource remoteDataSource;
  
  GameRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<String>>> searchImages(String query) async {
    try {
      final images = await remoteDataSource.searchImages(query);
      return Right(images);
    } on UnauthorizedException catch (e) {
      return const Left(UnauthorizedFailure('Invalid API key'));
    } on RateLimitExceededException {
      return const Left(RateLimitExceededFailure('API rate limit exceeded'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NoInternetException {
      return const Left(NoInternetFailure());
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  List<String> generateOfflineCards() {
    // Generate numbers 1-8, each repeated twice for matching pairs
    final List<String> cards = [];
    for (int i = 1; i <= 8; i++) {
      cards.add(i.toString());
      cards.add(i.toString());
    }
    return cards;
  }
}
