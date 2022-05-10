import 'dart:developer';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/core/error/failures.dart';
import 'package:test1/core/usecases/usecases.dart';
import 'package:test1/core/util/input_converter.dart';
import 'package:test1/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:test1/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input - the number must be  positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.inputConverter,
  });

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.StringToUnsignedInteger(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrTrivia =
              await concrete(Params(number: integer));
          yield failureOrTrivia.fold(
            (failure) => throw Error(
              message: _mapFailureToMessage(failure),
            ),
            (trivia) => Loaded(trivia: trivia),
          );
        },
      );
    }
    else if (event is GetTriviaForRandomNumber){

      yield Loading();
      final failureOrTrivia = await random(NoParams());
      yield failureOrTrivia!.fold(
            (failure) => throw Error(
          message: _mapFailureToMessage(failure),
        ),
            (trivia) => Loaded(trivia: trivia),
      );
    }
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
