part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;
  GetTriviaForConcreteNumber(this.numberString) ;
  @override
  // TODO: implement props
  List<Object?> get props =>[this.numberString];
 
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
