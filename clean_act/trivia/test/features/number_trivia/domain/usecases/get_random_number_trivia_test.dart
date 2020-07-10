import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRespostory extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRespostory mockNumberTriviaRespostory;

  setUp(() {
    mockNumberTriviaRespostory = MockNumberTriviaRespostory();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRespostory);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  test('should get trivia randomly from the respostory', () async {
    // arrange
    when(mockNumberTriviaRespostory.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRespostory.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRespostory);
  });
}
