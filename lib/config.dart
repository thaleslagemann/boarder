library config.globals;

import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';

MyTheme globalAppTheme = MyTheme();

class BoardDataStructure {
  String name;
  String description;

  BoardDataStructure(this.name, this.description);
}

class ConfigState extends ChangeNotifier {
  var boardsList = <String>[];
  List<BoardDataStructure> boards = [];
  var favoriteBoardsList = <String>[];

  int findIndexByElement(String elementToFind) {
    for (int i = 0; i < boards.length; i++) {
      if (boards[i].name == elementToFind ||
          boards[i].description == elementToFind) {
        return i;
      }
    }
    return -1; // Element not found
  }

  bool containsElement(String elementToCheck) {
    for (var board in boards) {
      if (board.name == elementToCheck || board.description == elementToCheck) {
        return true;
      }
    }
    return false; // Element not found in any pair
  }

  bool isElementUnique(String elementToCheck) {
    int count = 0;

    for (var board in boards) {
      if (board.name == elementToCheck) {
        count++;
      }
      if (board.description == elementToCheck) {
        count++;
      }
      // If count is greater than 1, element is not unique
      if (count > 1) {
        return false;
      }
    }

    return count == 1; // Element is unique if count is exactly 1
  }

  addBoard(value1, value2) {
    boards.add(BoardDataStructure(value1, value2));
    print('boards: $boards');
    notifyListeners();
  }

  deleteBoard(value) {
    var index = findIndexByElement(value);
    boards.removeAt(index);
    if (favoriteBoardsList.contains(value)) favoriteBoardsList.remove(value);
    notifyListeners();
  }

  updateBoard(boardName, newBoardName, newBoardDescription) {
    var index = findIndexByElement(boardName);
    if (index >= 0 && index < boards.length) {
      boards[index].name = newBoardName;
      boards[index].description = newBoardDescription;
    }
    if (favoriteBoardsList.contains(boardName)) {
      favoriteBoardsList[favoriteBoardsList.indexOf(boardName)] = newBoardName;
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
