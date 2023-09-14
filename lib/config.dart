library config.globals;

import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';

MyTheme globalAppTheme = MyTheme();

class ConfigState extends ChangeNotifier {
  var boardsList = <String>[];
  List<List<String>> boards = [];
  var favoriteBoardsList = <String>[];

  addBoard(value1, value2) {
    //boardsList.add(value1);
    boards.add([value1, value2]);
    print(boards);
    notifyListeners();
  }

  deletedBoard(value1, value2) {
    boards.remove([value1, value2]);
    if (favoriteBoardsList.contains(value1)) favoriteBoardsList.remove(value1);
    notifyListeners();
  }

  updateBoard(boardName, newboardName, newBoardDescription) {
    if (boards.contains(boardName)) {
      boards[boards.indexOf(boardName)] = [newboardName, newBoardDescription];
      print(boards[boards.indexOf(boardName)]);
    }
    if (favoriteBoardsList.contains(boardName)) {
      favoriteBoardsList[favoriteBoardsList.indexOf(boardName)] = newboardName;
    }
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
