library config.globals;

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';

MyTheme globalAppTheme = MyTheme();

class ConfigState extends ChangeNotifier {
  var current = WordPair.random();
  var boardsList = <String>[];
  var favoriteBoardsList = <String>[];

  addBoard() {
    boardsList.add(WordPair.random().toString());
    notifyListeners();
  }

  toggleFavBoard(value) {
    if (!favoriteBoardsList.contains(value)) {
      favoriteBoardsList.add(value);
    } else {
      favoriteBoardsList.remove(value);
    }
    notifyListeners();
  }

  doSomething() {
    print('Doing something.');
  }

  // Widget build(BuildContext context) {
  //   var themeState = context.watch<AppState>();

  // }
}
