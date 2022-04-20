import 'package:dartz/dartz.dart';

import '../failures.dart';

abstract class UseCase<Type, Params>{
  Future <Either<Failures, Type>> call(Params params);



}