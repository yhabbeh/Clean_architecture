

import 'package:test1/features/number_trivia/Data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  Future <NumberTriviaModel> getLastNumberTrivia();
  Future <void> cacheNumberTrivia(NumberTrivia triviaToCache);
  //تاكد انه النوع بالاقواس trivia مش trivia model

}