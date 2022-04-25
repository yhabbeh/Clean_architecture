import 'package:dartz/dartz.dart';
import 'package:test1/core/error/exceptions.dart';
import 'package:test1/core/error/failures.dart';
import 'package:test1/core/network/network_info.dart';
import 'package:test1/features/number_trivia/Data/datasources/number_trivia_local_data_source.dart';
import 'package:test1/features/number_trivia/Data/datasources/number_trivia_remote_data_source.dart';
import 'package:test1/features/number_trivia/domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number,) async {   
    return await _getTrivia(() {
    return remoteDataSource.getConcreteNumberTrivia(number);
  });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }




  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTrivia> Function() getConcreteOrRandom )async{

    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localNumber = await localDataSource.getLastNumberTrivia();
        return Right(localNumber);
      } on CashException {
        return Left(CacheFailure());
      };
    }

  }

}