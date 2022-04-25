import 'dart:convert';
import 'package:test1/core/error/exceptions.dart';
import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});


  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl(  path:"$number" );


  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl(  path:"random" );

  Future<NumberTriviaModel> _getTriviaFromUrl({required String path})
    async {
      final response = await client.get(
        Uri(
            scheme: 'https',
            host: 'numbersapi.com',
            path: '/$path/'  ),
      /*
       !!## Uri is class then you cant push url directly!!
         final httpsUri = Uri(
             scheme: 'https',
             host: 'dart.dev',
             path: 'guides/libraries/library-tour',
             fragment: 'numbers');
         print(httpsUri); // https://dart.dev/guides/libraries/library-tour#numbers
          %##% OR like :->  Uri.http('http://numbersapi.com','/$number')
     */
        headers: {'Content-Type': 'application/json'},
      );
      if (response == 200) {
        return NumberTriviaModel.fromJson(json.decode(response.body));
      } else
        throw ServerException();
    }
  }


