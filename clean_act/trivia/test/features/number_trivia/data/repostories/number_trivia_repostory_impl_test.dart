import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/core/error/exceptions.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/network/network_info.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepostoryImp repostoryImp;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(
    () {
      mockRemoteDataSource = MockRemoteDataSource();
      mockLocalDataSource = MockLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repostoryImp = NumberTriviaRepostoryImp(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    },
  );
  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(
        () {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        },
      );

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(
        () {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        },
      );
      body();
    });
  }

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel(text: 'test text', number: tNumber);
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repostoryImp.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      runTestOnline(
        () {
          test(
            'should return remote data when call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result =
                  await repostoryImp.getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(result, equals(Right(tNumberTrivia)));
            },
          );
          test(
            'should cache the data locally when call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              await repostoryImp.getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );
          test(
            'should return server failure data when call to remote data source is unsuccessful',
            () async {
              // arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenThrow(ServerException());
              // act
              final result =
                  await repostoryImp.getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );
      runTestOffline(
        () {
          test(
            'should return last cached data when cached data is present',
            () async {
              // arrange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result =
                  await repostoryImp.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Right(tNumberTrivia)));
            },
          );
          test(
            'should return CacheFailure when there is no cached data present',
            () async {
              // arrange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              // act
              final result =
                  await repostoryImp.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
  group(
    'getRandomNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel(text: 'test text', number: 123);
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repostoryImp.getRandomNumberTrivia();
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      runTestOnline(
        () {
          test(
            'should return remote data when call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await repostoryImp.getRandomNumberTrivia();
              // assert
              verify(mockRemoteDataSource.getRandomNumberTrivia());
              expect(result, equals(Right(tNumberTrivia)));
            },
          );
          test(
            'should cache the data locally when call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              await repostoryImp.getRandomNumberTrivia();
              // assert
              verify(mockRemoteDataSource.getRandomNumberTrivia());
              verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );
          test(
            'should return server failure data when call to remote data source is unsuccessful',
            () async {
              // arrange
              when(mockRemoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());
              // act
              final result = await repostoryImp.getRandomNumberTrivia();
              // assert
              verify(mockRemoteDataSource.getRandomNumberTrivia());
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );
      runTestOffline(
        () {
          test(
            'should return last cached data when cached data is present',
            () async {
              // arrange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await repostoryImp.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Right(tNumberTrivia)));
            },
          );
          test(
            'should return CacheFailure when there is no cached data present',
            () async {
              // arrange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              // act
              final result = await repostoryImp.getRandomNumberTrivia();
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
}
