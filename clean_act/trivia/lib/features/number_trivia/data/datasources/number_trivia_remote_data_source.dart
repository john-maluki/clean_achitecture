import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trivia/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({
    @required this.client,
  });
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
