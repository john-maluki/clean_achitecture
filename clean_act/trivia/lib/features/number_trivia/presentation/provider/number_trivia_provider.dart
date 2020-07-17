import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/util/input_converter.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

abstract class NumberTriviaProvider extends ChangeNotifier {}

class NumberTriviaProviderImpl extends NumberTriviaProvider {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTrivia numberTrivia;

  NumberTriviaProviderImpl({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  Future<NumberTrivia> getNumberForConcreteTrivia(numberString) async {
    final numberParsed = inputConverter.stringToUnSignInteger(numberString);
    numberParsed.fold((failure) {
      throw Exception();
    }, (number) async {
      final ret = await getConcreteNumberTrivia(Params(number: number));
      ret.fold((l) => ServerFailure(), (trivia) {
        numberTrivia = trivia;
        notifyListeners();
      });
    });

    return numberTrivia;
  }

  Future<NumberTrivia> getNumberForRandomTrivia() async {
    final randomTrivia = await getRandomNumberTrivia(NoParams());
    randomTrivia.fold((l) => throw ServerFailure(), (trivia) {
      numberTrivia = trivia;
      notifyListeners();
    });
    // notifyListeners();
    return numberTrivia;
  }
}
