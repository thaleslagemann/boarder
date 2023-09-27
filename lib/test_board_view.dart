import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class HeaderStructure {
  final int id;
  String name;
  List<int> taskIdList;

  HeaderStructure(
      {required this.id, required this.name, required this.taskIdList});
}

class TaskStructure {
  final int id;
  String name;

  TaskStructure({required this.id, required this.name});
}

class BasicExample extends StatefulWidget {
  const BasicExample({Key? key}) : super(key: key);

  @override
  State createState() => _BasicExample();
}

class _BasicExample extends State<BasicExample> {
  List<HeaderStructure> headers = [];
  List<TaskStructure> tasks = [];
  final TextEditingController _headerFieldController = TextEditingController();
  final TextEditingController _taskFieldController = TextEditingController();
  final TextEditingController _headerRenameFieldController =
      TextEditingController();
  String newHeaderName = '';
  String newTaskName = '';
  String renameHeaderNewName = '';

  @override
  void initState() {
    super.initState();
  }

  bool containsElement(List<dynamic> list, elementToCheck) {
    for (var element in list) {
      if (element.id == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  int findIndexByID(List<dynamic> list, int id) {
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findIndexByElement(List list, String elementToFind) {
    if (list.isEmpty) {
      print("At FindIndexByElement(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].name == elementToFind) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int getContentIndex(List<HeaderStructure> list, String elementToFind) {
    if (list.isEmpty) {
      print("At FindIndexByElement(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].name == elementToFind) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int getSequentialID(List<dynamic> list, int id) {
    if (containsElement(list, id)) {
      id = id + 1;
      return getSequentialID(list, id);
    }
    return id;
  }

  Future<void> _displayHeaderInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create a new header'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  newHeaderName = value;
                });
              },
              autofocus: true,
              controller: _headerFieldController,
              decoration: const InputDecoration(hintText: "Header name"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  setState(() {
                    newHeaderName = _headerFieldController.text;
                    print(newHeaderName);
                    pushHeaderIntoList(newHeaderName);
                    newHeaderName = '';
                    _headerFieldController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTaskInputDialog(
      BuildContext context, int headerID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create a new task'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  newTaskName = value;
                });
              },
              autofocus: true,
              controller: _taskFieldController,
              decoration: const InputDecoration(hintText: "Task name"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  setState(() {
                    newTaskName = _taskFieldController.text;
                    print(newTaskName);
                    var taskID = getSequentialID(tasks, 0);
                    pushItemIntoList(
                        findIndexByID(headers, headerID), taskID, newTaskName);
                    newTaskName = '';
                    _taskFieldController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayHeaderRenameDialog(
      BuildContext context, int headerID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Rename header'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  renameHeaderNewName = value;
                });
              },
              autofocus: true,
              controller: _headerRenameFieldController,
              decoration: const InputDecoration(hintText: "New header name"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  setState(() {
                    renameHeaderNewName = _headerRenameFieldController.text;
                    print(renameHeaderNewName);
                    renameHeaderAt(headerID, renameHeaderNewName);
                    Navigator.pop(context);
                    renameHeaderNewName = '';
                    _headerRenameFieldController.clear();
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayHeaderDeletionConfirmationDialog(
      BuildContext context, int headerID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete header?'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  setState(() {
                    removeHeader(headerID);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  pushHeaderIntoList(String headerName) {
    var headerID = getSequentialID(headers, 0);
    List<int> taskIdList = [];
    headers.add(HeaderStructure(
        id: headerID, name: headerName, taskIdList: taskIdList));
    for (var i = 0; i < headers.length; i++) {
      print('[${headers[i].id}, ${headers[i].name}]');
    }
  }

  pushItemIntoList(int headerIndex, int taskID, String taskName) {
    tasks.add(TaskStructure(id: taskID, name: taskName));
    headers[headerIndex].taskIdList.add(taskID);
  }

  void renameHeaderAt(int headerID, String newName) {
    int index = findIndexByID(headers, headerID);
    headers[index].name = newName;
    print('Updated Header: [${headers[index].id}, ${headers[index].name}]');
    print('Headers list:');
    for (var i = 0; i < headers.length; i++) {
      print("[${headers[i].id}, ${headers[i].name}]");
    }
  }

  void removeHeader(int headerID) {
    int index = findIndexByID(headers, headerID);
    var removedHeader = headers.removeAt(index);
    print('Removed Header: [${removedHeader.id}, ${removedHeader.name}]');
    print('Headers list:');
    for (var i = 0; i < headers.length; i++) {
      print("[${headers[i].id}, ${headers[i].name}]");
    }
  }

  void choiceAction(String choice, int headerID) {
    if (choice == Constants.Delete) {
      print(
          'Removing header ${headers[findIndexByID(headers, headerID)].name}');
      _displayHeaderDeletionConfirmationDialog(context, headerID);
    } else if (choice == Constants.Rename) {
      _displayHeaderRenameDialog(context, headerID);
    } else if (choice == Constants.ThirdItem) {
      print('I Third Item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.inverseSurface,
        backgroundColor: Color(0xFF4FC3F7),
        onPressed: () {
          _displayHeaderInputDialog(context);
          print(newHeaderName);
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: DragAndDropLists(
        children: [
          for (var header in headers)
            DragAndDropList(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_sharp),
                    itemBuilder: (BuildContext context) {
                      return Constants.choices.map((String choice) {
                        return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                            onTap: () => {
                                  setState(() {
                                    choiceAction(choice, header.id);
                                  })
                                });
                      }).toList();
                    },
                  ),
                  const Expanded(
                    flex: 1,
                    child: Divider(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(header.name),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Divider(),
                  ),
                  IconButton(
                      onPressed: () {
                        _displayTaskInputDialog(context, header.id);
                      },
                      icon: Icon(Icons.add)),
                ],
              ),
              children: <DragAndDropItem>[
                for (var task in header.taskIdList)
                  if (tasks[findIndexByID(tasks, task)].id == task)
                    DragAndDropItem(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.5)),
                            border: Border.all(
                                width: 0.5,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface)),
                        child: Stack(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    tasks[findIndexByID(tasks, task)].name,
                                    softWrap: true),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    IconButton(
                                      onPressed: () => {
                                        print(tasks[findIndexByID(tasks, task)]
                                            .name)
                                      },
                                      icon:
                                          Icon(Icons.keyboard_arrow_down_sharp),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
              ],
            ),
        ],
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
      )),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = headers[oldListIndex].taskIdList.removeAt(oldItemIndex);
      headers[newListIndex].taskIdList.insert(newItemIndex, movedItem);
      print('[$oldItemIndex, $oldListIndex] -> [$newItemIndex, $newListIndex]');
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = headers.removeAt(oldListIndex);
      headers.insert(newListIndex, movedList);
    });
  }
}

class Constants {
  static const String Delete = 'Delete';
  static const String Rename = 'Rename';
  static const String ThirdItem = 'Third Item';

  static const List<String> choices = <String>[
    Delete,
    Rename,
    ThirdItem,
  ];
}
