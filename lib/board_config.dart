// import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class HeaderStructure {
//   final int id;
//   String name;
//   late DragAndDropList content;

//   HeaderStructure(
//       {required this.id, required this.name, required this.content});
// }

// class BasicExample extends ChangeNotifier {
//   List<HeaderStructure> headers = [];
//   final TextEditingController _headerFieldController = TextEditingController();
//   final TextEditingController _taskFieldController = TextEditingController();
//   final TextEditingController _headerRenameFieldController =
//       TextEditingController();
//   String newHeaderName = '';
//   String newTaskName = '';
//   String renameHeaderNewName = '';

//   late Database localDB;
//   bool loadingDB = true;

//   loadDB() async {
//     if (loadingDB) {
//       print('Loading DB: $loadingDB');
//       var databasesPath = await getDatabasesPath();
//       print('databasesPath: $databasesPath');
//       String path = join(databasesPath, 'local_boards_db.db');
//       print('LocalDB path: $path');
//       localDB = await openDatabase(path, version: 1,
//           onCreate: (Database db, int version) async {
//         await db.execute(
//             'CREATE TABLE [IF NOT EXISTS] boardHeader (headerId INTEGER PRIMARY KEY, boardId INTEGER FOREIGN KEY, headerName TEXT)');
//         await db.execute(
//             'CREATE TABLE [IF NOT EXISTS] headerTask (headerId INTEGER FOREIGN KEY, taskDescription TEXT)');
//       });
//       List<Map> boardHeader = await localDB.rawQuery('SELECT * FROM boards');
//       convertRawQueryToBoardHeader(boardHeader);
//       print('Boards $boardHeader');
//       //await localDB.execute('DELETE FROM favoriteBoards WHERE id = 1');
//       List<Map> headerTask =
//           await localDB.rawQuery('SELECT * FROM favoriteBoards');
//       convertRawQueryToHeaderTask(headerTask);
//       print('FavoriteBoards: $headerTask');
//       print('DB loaded');
//       loadingDB = false;
//       print('Loading DB: $loadingDB');
//       notifyListeners();
//     }
//   }

//   convertRawQueryToBoardHeader(List<Map> rawQuery) {
//     for (var i = 0; i < rawQuery.length; i++) {
//       int id = rawQuery[i].values.elementAt(0);
//       String name = rawQuery[i].values.elementAt(1).toString();

//       DragAndDropList content = generateHeader(name, id);

//       HeaderStructure board =
//           HeaderStructure(id: id, name: name, content: DragAndDropList);

//       if (!containsElement(headers, board)) {
//         headers.add(board);
//       }
//       print('On Convert Statement: [${board.id},${board.name}]');
//     }
//   }

//   convertRawQueryToHeaderTask(headerTask) {}

//   generateHeader(String headerName, int headerID) {
//     return DragAndDropList(
//       header: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           PopupMenuButton<String>(
//             icon: Icon(Icons.more_vert_sharp),
//             itemBuilder: (BuildContext context) {
//               return Constants.choices.map((String choice) {
//                 return PopupMenuItem<String>(
//                     value: choice, child: Text(choice), onTap: () => {});
//               }).toList();
//             },
//           ),
//           const Expanded(
//             flex: 1,
//             child: Divider(),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             child: Text(headerName),
//           ),
//           const Expanded(
//             flex: 1,
//             child: Divider(),
//           ),
//           IconButton(
//               onPressed: () {
//                 _displayTaskInputDialog(context, headerName);
//               },
//               icon: Icon(Icons.add)),
//         ],
//       ),
//       children: <DragAndDropItem>[],
//     );
//   }

//   bool containsElement(List<HeaderStructure> list, elementToCheck) {
//     for (var element in list) {
//       if (element.id == elementToCheck) {
//         return true;
//       }
//     }
//     return false;
//   }

//   int findIndexByID(List<HeaderStructure> list, int id) {
//     if (list.isEmpty) {
//       print("At FindIndexByID(): List is empty; returning index (-1)");
//       return -1;
//     }
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].id == id) {
//         return i;
//       }
//     }
//     print("At FindIndexByElement(): Element not found; returning index (-1)");
//     return -1;
//   }

//   int findIndexByElement(List list, String elementToFind) {
//     if (list.isEmpty) {
//       print("At FindIndexByElement(): List is empty; returning index (-1)");
//       return -1;
//     }
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].name == elementToFind) {
//         return i;
//       }
//     }
//     print("At FindIndexByElement(): Element not found; returning index (-1)");
//     return -1;
//   }

//   int getContentIndex(List<HeaderStructure> list, String elementToFind) {
//     if (list.isEmpty) {
//       print("At FindIndexByElement(): List is empty; returning index (-1)");
//       return -1;
//     }
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].name == elementToFind) {
//         return i;
//       }
//     }
//     print("At FindIndexByElement(): Element not found; returning index (-1)");
//     return -1;
//   }

//   int getSequentialID(List<HeaderStructure> list, int id) {
//     if (containsElement(list, id)) {
//       id = id + 1;
//       return getSequentialID(list, id);
//     }
//     return id;
//   }

//   void renameHeaderAt(int headerID, String newName) {
//     int index = findIndexByID(headers, headerID);
//     headers[index].name = newName;
//     print('Updated Header: [${headers[index].id}, ${headers[index].name}]');
//     print('Headers list:');
//     for (var i = 0; i < headers.length; i++) {
//       print("[${headers[i].id}, ${headers[i].name}]");
//     }
//   }

//   void removeHeader(int headerID) {
//     int index = findIndexByID(headers, headerID);
//     var removedHeader = headers.removeAt(index);
//     print('Removed Header: [${removedHeader.id}, ${removedHeader.name}]');
//     print('Headers list:');
//     for (var i = 0; i < headers.length; i++) {
//       print("[${headers[i].id}, ${headers[i].name}]");
//     }
//   }

//   List<DragAndDropList> listHeaders() {
//     List<DragAndDropList> list = [];
//     for (var element in headers) {
//       list.add(element.content);
//     }
//     return list;
//   }
// }

// class Constants {
//   static const String Delete = 'Delete';
//   static const String Rename = 'Rename';
//   static const String ThirdItem = 'Third Item';

//   static const List<String> choices = <String>[
//     Delete,
//     Rename,
//     ThirdItem,
//   ];
// }
