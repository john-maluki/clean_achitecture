import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page_p.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: ChangeNotifierProvider<NumberTriviaProviderImpl>(
        create: (context) => NumberTriviaProviderImpl(
          concrete: sl(),
          random: sl(),
          inputConverter: sl(),
        ),
        child: NumberTriviaProScreen(),
      ),
    );
  }
}
