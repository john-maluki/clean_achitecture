import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:trivia/features/number_trivia/presentation/widgets/message_display.dart';

class NumberTriviaProScreen extends StatefulWidget {
  @override
  _NumberTriviaProScreenState createState() => _NumberTriviaProScreenState();
}

class _NumberTriviaProScreenState extends State<NumberTriviaProScreen> {
  final txtController = TextEditingController();
  String inputStr;
  NumberTrivia numberTrivia;

  @override
  void didChangeDependencies() {
    numberTrivia = Provider.of<NumberTriviaProviderImpl>(context).numberTrivia;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build 1');
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Triva App_P'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              // Top Half
              Column(
                children: <Widget>[
                  numberTrivia == null
                      ? Center(
                          child: Text('Start searching'),
                        )
                      : FutureBuilder<NumberTrivia>(
                          future: Future.value(numberTrivia),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DisplayMessage(
                                numberTrivia: snapshot.data,
                              );
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: txtController,
                    onChanged: (value) {
                      inputStr = value;
                    },
                    onSubmitted: (_) {
                      getConcreteTrivia();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Input a number',
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text('Search'),
                      onPressed: getConcreteTrivia,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text('Get random trivia'),
                      onPressed: getRandomTrivia,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void getConcreteTrivia() async {
    txtController.clear();
    numberTrivia =
        await Provider.of<NumberTriviaProviderImpl>(context, listen: false)
            .getNumberForConcreteTrivia(inputStr);
  }

  void getRandomTrivia() async {
    numberTrivia =
        await Provider.of<NumberTriviaProviderImpl>(context, listen: false)
            .getNumberForRandomTrivia();
  }
}

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({
    Key key,
    @required this.numberTrivia,
  }) : super(key: key);

  final NumberTrivia numberTrivia;

  @override
  Widget build(BuildContext context) {
    print('build 2');
    return Column(
      children: <Widget>[
        Text(
          numberTrivia.number.toString(),
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          child: Text(
            numberTrivia.text,
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
