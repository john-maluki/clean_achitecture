import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(
    () {
      inputConverter = InputConverter();
    },
  );

  group(
    'stringToUnSignedInt',
    () {
      test(
        'should return an intenger when string represents an unsigned integer',
        () {
          // arrange
          final str = '123';
          // act
          final result = inputConverter.stringToUnSignInteger(str);
          // assert
          expect(result, Right(123));
        },
      );
      test(
        'should return a Failure when the string is not integer',
        () {
          // arrange
          final str = 'abc';
          // act
          final result = inputConverter.stringToUnSignInteger(str);
          // assert
          expect(result, Left(InvalidInputFailure()));
        },
      );
      test(
        'should return a Failure when the string is a negative integer',
        () {
          // arrange
          final str = '-123';
          // act
          final result = inputConverter.stringToUnSignInteger(str);
          // assert
          expect(result, Left(InvalidInputFailure()));
        },
      );
    },
  );
}
