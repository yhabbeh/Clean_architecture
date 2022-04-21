import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
 final List failure;
 Failure({required this.failure});

}
class ServerFailure extends Failure  {
  ServerFailure({required List failure}) : super(failure: failure);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CashFailure extends Failure {
  CashFailure({required List failure}) : super(failure: failure);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}//ask ammar abu srour