import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/util/input_converter.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(
    () {
      mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      mockInputConverter = MockInputConverter();
      bloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter);
    },
  );

  test(
    'initialState should be empty',
    () {
      // assert
      expect(bloc.initialState, equals(Empty()));
    },
  );
  group(
    'GetTriviaForConcreteNumber',
    () {
      final tNumberString = '1';
      final tNumberParsed = 1;
      final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

      void setUpMockInputConverterSuccess() =>
          when(mockInputConverter.stringToUnSignInteger(any))
              .thenReturn(Right(tNumberParsed));

      test(
        'should call the input converter to validate and convert string to unsigned integer',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          // act
          bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnSignInteger(any));
          // assert
          verify(mockInputConverter.stringToUnSignInteger(tNumberString));
        },
      );
      test(
        'should emit [Error] when input is invalid',
        () {
          // arrange
          when(mockInputConverter.stringToUnSignInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          // assert later
          final expected = [
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        },
      );
      test(
        'should get data from concrete use case',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // act
          bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));
          // assert
          verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
        },
      );
      test(
        'should emit [loading, loaded] when data is gotten successfully',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Loaded(numberTrivia: tNumberTrivia),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        },
      );
      test(
        'should emit [loading, error] when getting data fails',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        },
      );
      test(
        'should emit [loading, error] when getting data fails and is Cache Failure',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        },
      );
    },
  );
  group(
    'GetTriviaForRandomNumber',
    () {
      final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

      test(
        'should get data from random use case',
        () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // act
          bloc.dispatch(GetTriviaForRandomNumber());
          await untilCalled(mockGetRandomNumberTrivia(any));
          // assert
          verify(mockGetRandomNumberTrivia(NoParams()));
        },
      );
      test(
        'should emit [loading, loaded] when data is gotten successfully',
        () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Loaded(numberTrivia: tNumberTrivia),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForRandomNumber());
        },
      );
      test(
        'should emit [loading, error] when getting data fails',
        () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForRandomNumber());
        },
      );
      test(
        'should emit [loading, error] when getting data fails and is Cache Failure',
        () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForRandomNumber());
        },
      );
    },
  );
}
