import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/core/network/network_info.dart';
import 'package:test1/core/util/input_converter.dart';
import 'package:test1/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:test1/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:test1/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:test1/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:test1/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:test1/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart'as http;

import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';

final sl = GetIt.instance;

Future<void> init() async{
  //! Features - Number Trivia
  //Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));

  //UseCase
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      networkInfo: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  //Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final  sSharedPreferences =await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sSharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
