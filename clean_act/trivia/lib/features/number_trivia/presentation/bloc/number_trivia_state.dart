part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]);
}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;
  Loaded({@required this.numberTrivia});
  @override
  List<Object> get props => [numberTrivia];
}

class Error extends NumberTriviaState {
  final String message;
  Error({@required this.message});
  @override
  List<Object> get props => [message];
}
