part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent {
  NumberTriviaEvent();
  // @override
  // List<Object> get props => this.props;
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;
  GetTriviaForConcreteNumber(this.numberString);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
