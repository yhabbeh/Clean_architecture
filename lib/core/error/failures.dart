import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
 late final List failure;
}
class ServerFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CacheFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
//ask ammar abu srour