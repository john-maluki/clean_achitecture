import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      //assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromJSON',
    () {
      test(
        'should return a valid model when json number is integer',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
        'should return a valid model when json number is double',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('double_trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
    },
  );

  group(
    'toJSON',
    () {
      test(
        'should return a valid jsonMap containing a valid data',
        () async {
          // act
          final result = tNumberTriviaModel.toJson();
          // assert
          final expectedMap = {
            "text": "test text",
            "number": 1,
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}
