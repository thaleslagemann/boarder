library config.globals;

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';

MyTheme currentTheme = MyTheme();

class ConfigState extends ChangeNotifier {
  var current = WordPair.random();
  var boardsList = <String>[];

  addBoard() {
    boardsList.add(WordPair.random().toString());
    notifyListeners();
  }

  doSomething() {
    print('Doing something.');
  }

  // Widget build(BuildContext context) {
  //   var themeState = context.watch<AppState>();

  // }
}
