import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRespository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRespository mockNumberTriviaRespository;

  setUp(() {
    mockNumberTriviaRespository = MockNumberTriviaRespository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRespository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRespository.getConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Right(tNumberTrivia),
      );
      // act
      final result = await usecase(Params(number: tNumber));
      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRespository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRespository);
    },
  );
}
