// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failures, Type>>? call(Params params);
}

mixin NoParams implements Equatable {}
