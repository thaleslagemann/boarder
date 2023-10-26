// ignore_for_file: constant_identifier_names

library config.globals;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/db_handler.dart';
import 'package:kanban_flt/reorder_settings.dart';
import 'package:kanban_flt/themes.dart';

MyTheme globalAppTheme = MyTheme();
ReorderSettings reorderType = ReorderSettings();

class Constants {
  static const String AddTask = 'Add Task';
  static const String Delete = 'Delete';
  static const String Rename = 'Rename';
  static const String Edit = 'Edit';
  static const String Bookmark = 'Bookmark';
  static const String Details = 'Details';

  static const List<String> headerChoices = <String>[
    AddTask,
    Rename,
    Delete,
  ];
  static const List<String> taskChoices = <String>[
    Rename,
    Delete,
  ];
  static const List<String> boardChoices = <String>[
    Details,
    Edit,
    Delete,
  ];
  static const List<String> boardListChoices = <String>[
    Bookmark,
    Edit,
    Delete,
  ];
}

class ConfigState extends ChangeNotifier {
  bool loadingDB = true;

  final databaseHelper = DatabaseHelper.instance;

  void loadDB() async {
    if (loadingDB) {
      print('Loading DB: $loadingDB');
      await databaseHelper.initializeDatabase();
      databaseHelper.boards = await databaseHelper.getAllBoards();
      for (var board in databaseHelper.boards) {
        print("Searching headers for board [${board.name}]...");
        databaseHelper.boards[findBoardIndexByID(board.boardId)].headers =
            await databaseHelper.getHeadersForBoard(board.boardId);
        for (var header in board.headers) {
          print("Header found: [${header.headerId}, ${header.name}]");
          databaseHelper.addHeader(header);
        }
        if (board.headers.isEmpty) {
          print('No headers found!');
        } else {
          for (var header in board.headers) {
            print("Searching tasks for header [${header.name}]...");
            header.tasks =
                await databaseHelper.getTasksForHeader(header.headerId);
            for (var task in header.tasks) {
              print(
                  "Task found: [ID: ${task.taskId}, NAME: ${task.name}, ORDER_ID: ${task.orderIndex}]");
              databaseHelper.addTask(task);
            }
            if (header.tasks.isEmpty) {
              print('No tasks found!');
            }
          }
        }
      }
      databaseHelper.sortHeadersAndTasks();
      databaseHelper.bookmarks = await databaseHelper.getAllBookmarks();
      List<Bookmark> badBookmarks = [];
      for (var bookmark in databaseHelper.bookmarks) {
        if (!containsBoardId(bookmark.boardId)) {
          badBookmarks.add(bookmark);
        }
      }
      for (var b in badBookmarks) {
        databaseHelper.bookmarks.remove(b);
      }
      print("Boards:");
      if (databaseHelper.boards.isEmpty) {
        print("No boards found!");
      } else {
        for (var board in databaseHelper.boards) {
          print("[ID: ${board.boardId}, NAME: ${board.name}]");
        }
      }
      print("Bookmarks:");
      if (databaseHelper.bookmarks.isEmpty) {
        print("No bookmarks found!");
      } else {
        for (var bookmark in databaseHelper.bookmarks) {
          print(
              "[BookmarkID: ${bookmark.bookmarkId}, BoardID: ${bookmark.boardId}]");
        }
      }
      print("Headers:");
      if (databaseHelper.headers.isEmpty) {
        print("No headers found!");
      } else {
        print('| ID  \tNAME    \tPARENT_ID\t ORDER_ID |');
        for (var board in databaseHelper.boards) {
          for (var header in board.headers) {
            print(
                "| ${header.headerId.toStringAsPrecision(7)}\t${header.name.padRight(14)}\t${header.boardId.toStringAsPrecision(7)}\t ${header.orderIndex.toStringAsPrecision(7)} |");
          }
        }
      }
      print("Tasks:");
      printTasks();
      print('DB loaded');
      loadingDB = false;
      print('Loading DB: $loadingDB');
      notifyListeners();
    }
  }

  void printTasks() {
    if (databaseHelper.tasks.isEmpty) {
      print("No tasks found!");
    } else {
      print('| ID  \tNAME    \tPARENT_ID\t ORDER_ID |');
      for (var board in databaseHelper.boards) {
        for (var header in board.headers) {
          for (var task in header.tasks) {
            print(
                "| ${task.taskId.toStringAsPrecision(7)}\t${task.name.padRight(14)}\t${task.headerId.toStringAsPrecision(7)}\t ${task.orderIndex.toStringAsPrecision(7)} |");
          }
        }
      }
    }
  }

  int findIndexByElement(List<dynamic> list, String elementToFind) {
    if (list.isEmpty) {
      print("At FindIndexByElement(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].name == elementToFind ||
          list[i].description == elementToFind) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findBoardIndexByID(int id) {
    List<dynamic> list = databaseHelper.boards;
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].boardId == id) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findHeaderIndexByID(int id) {
    List<dynamic> list = databaseHelper.headers;
    if (list.isEmpty) {
      print("At FindHeaderIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].headerId == id) {
        return i;
      }
    }
    print("At FindHeaderIndexByID(): Element not found; returning index (-1)");
    return -1;
  }

  int findHeaderIndexByOrderId(int id, Board board) {
    List<dynamic> list = board.headers;
    print("Searching [$id] on board ${board.name}");
    if (list.isEmpty) {
      print(
          "At FindHeaderIndexByOrderId(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].orderIndex == id) {
        return i;
      }
    }
    print(
        "At FindHeaderIndexByOrderId(): Element not found; returning index (-1)");
    return -1;
  }

  int findTaskIndexByID(int id) {
    List<dynamic> list = databaseHelper.tasks;
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].taskId == id) {
        return i;
      }
    }
    print("At FindIndexByID(): Element not found; returning index (-1)");
    return -1;
  }

  int findTaskIndexByOrderId(int id, int listId, Board board) {
    int headerIndex = findHeaderIndexByOrderId(listId, board);
    List<dynamic> list = board.headers[headerIndex].tasks;
    print(
        "Searching [$id] on board ${board.name} on header ${board.headers[headerIndex].name}");

    for (var task in list) {
      print('[O.I.: ${task.orderIndex}, NAME: ${task.name}]');
    }
    if (list.isEmpty) {
      print("At FindTaskIndexByOrderId(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].orderIndex == id) {
        return i;
      }
    }
    print(
        "At FindTaskIndexByOrderId(): Element not found; returning index (-1)");
    return -1;
  }

  void printAllElements(List<dynamic> list) {
    for (var element in list) {
      print('All Elements on $list:');
      print('[${element.id}, ${element.name}]');
    }
  }

  bool containsBoard(List<dynamic> list, elementToCheck) {
    for (var board in list) {
      if (board.boardId == elementToCheck ||
          board.name == elementToCheck ||
          board.description == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsBoardId(int elementToCheck) {
    List<Board> list = databaseHelper.boards;
    for (var board in list) {
      if (board.boardId == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsBookmark(List<Bookmark> list, elementToCheck) {
    for (var bookmark in list) {
      if (bookmark.boardId == elementToCheck ||
          bookmark.bookmarkId == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsHeader(List<dynamic> list, elementToCheck) {
    for (var header in list) {
      if (header.headerId == elementToCheck || header.name == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsTask(List<dynamic> list, elementToCheck) {
    for (var element in list) {
      if (element.taskId == elementToCheck || element.name == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool isElementUnique(elementToCheck) {
    int count = 0;

    for (var board in databaseHelper.boards) {
      if (board.boardId == elementToCheck) {
        count++;
      }
      if (board.name == elementToCheck) {
        count++;
      }
      if (board.description == elementToCheck) {
        count++;
      }
      if (count > 1) {
        print("At isElementUnique(): Element is not unique.");
        return false;
      }
    }
    print("At isElementUnique(): Element is unique.");
    return count == 1;
  }

  int getSequentialID(List<dynamic> list, int id) {
    if (containsBoard(list, id)) {
      id = id + 1;
      return getSequentialID(list, id);
    }

    print('At getSequentialID: New board ID is $id');
    return id;
  }

  int getSequentialHeaderID(int id) {
    List<dynamic> list = databaseHelper.headers;
    if (containsHeader(list, id)) {
      id = id + 1;
      return getSequentialHeaderID(id);
    }

    print('At getSequentialHeaderID: New header ID is $id');
    return id;
  }

  int getSequentialTaskID(List<dynamic> list, int id) {
    if (containsTask(list, id)) {
      id = id + 1;
      return getSequentialTaskID(list, id);
    }

    print('At getSequentialTaskID: New task ID is $id');
    return id;
  }
}
