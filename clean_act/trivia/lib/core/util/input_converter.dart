import 'package:dartz/dartz.dart';
import 'package:trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnSignInteger(String str) {
    try {
      final interger = int.parse(str);

      if (interger < 0) {
        throw FormatException();
      }
      return Right(interger);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
