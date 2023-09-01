import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kanban_flt/home_page.dart';
import 'package:kanban_flt/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Kanban Flutter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green).copyWith(
            secondary: Colors.green,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green).copyWith(
            secondary: Colors.green,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: currentTheme.currentTheme(),
        home: HomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var current = WordPair.random();
  var boardsList = <String>[];

  addBoard() {
    boardsList.add(WordPair.random().toString());
    notifyListeners();
  }

  doSomething() {
    print('Button was clicked.');
  }
}
