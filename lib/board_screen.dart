library config.globals;

// ignore_for_file: unused_field
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/update_board_form.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen(
      {super.key,
      required this.boardID,
      required this.boardName,
      required this.boardDescription});

  final int boardID;
  final String boardName;
  final String boardDescription;

  @override
  BoardScreenState createState() => BoardScreenState();
}

class BoardScreenState extends State<BoardScreen> {
  late bool _bookmarkSwitch;

  final TextEditingController _headerFieldController = TextEditingController();
  final TextEditingController _taskFieldController = TextEditingController();
  final TextEditingController _headerRenameFieldController =
      TextEditingController();
  String newHeaderName = '';
  String newTaskName = '';
  String renameHeaderNewName = '';

  Icon bookmarkIconSwitch() {
    switch (_bookmarkSwitch) {
      case true:
        return Icon(Icons.bookmark_sharp);
      case false:
        return Icon(Icons.bookmark_border_sharp);
    }
    return Icon(Icons.bookmark_sharp);
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

    showAlert(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete the board?'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  configState.deleteBoard(widget.boardID);
                  if (!configState.containsElement(
                      configState.boards, widget.boardID)) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Board deleted')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('An error occured on board deletion')),
                    );
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel'),
              ),
            ],
          );
        },
      );
    }

    Future<void> _displayHeaderRenameDialog(
        BuildContext context, int headerID) async {
      _headerRenameFieldController.text = configState
          .headers[configState.findIndexByID(configState.headers, headerID)]
          .name;
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
                      configState.renameHeaderAt(headerID, renameHeaderNewName);
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
                      configState.removeHeader(headerID);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
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
                      configState.pushHeaderIntoList(newHeaderName);
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
                      var taskID =
                          configState.getSequentialTaskID(configState.tasks, 0);
                      configState.pushItemIntoList(
                          configState.findIndexByID(
                              configState.headers, headerID),
                          taskID,
                          newTaskName);
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

    _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
        int newListIndex) {
      setState(() {
        var movedItem =
            configState.headers[oldListIndex].taskIdList.removeAt(oldItemIndex);
        configState.headers[newListIndex].taskIdList
            .insert(newItemIndex, movedItem);
        print(
            '[$oldItemIndex, $oldListIndex] -> [$newItemIndex, $newListIndex]');
      });
    }

    _onListReorder(int oldListIndex, int newListIndex) {
      setState(() {
        var movedList = configState.headers.removeAt(oldListIndex);
        configState.headers.insert(newListIndex, movedList);
      });
    }

    checkBookmarkState() {
      if (configState.containsElement(
          configState.favoriteBoards, widget.boardName)) {
        _bookmarkSwitch = true;
      } else {
        _bookmarkSwitch = false;
      }
    }

    checkBookmarkState();

    void choiceAction(String choice, int headerID) {
      if (choice == Constants.Delete) {
        print(
            'Removing header ${configState.headers[configState.findIndexByID(configState.headers, headerID)].name}');
        _displayHeaderDeletionConfirmationDialog(context, headerID);
      } else if (choice == Constants.Rename) {
        _displayHeaderRenameDialog(context, headerID);
      } else if (choice == Constants.ThirdItem) {
        print('I Third Item');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.inverseSurface,
        backgroundColor: Color(0xFF4FC3F7),
        onPressed: () {
          _displayHeaderInputDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          50,
                      width: MediaQuery.of(context).size.width,
                      child: DragAndDropLists(
                        children: [
                          for (var header in configState.headers)
                            DragAndDropList(
                              header: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_sharp),
                                    itemBuilder: (BuildContext context) {
                                      return Constants.choices
                                          .map((String choice) {
                                        return PopupMenuItem<String>(
                                            value: choice,
                                            child: Text(choice),
                                            onTap: () => {
                                                  setState(() {
                                                    choiceAction(
                                                        choice, header.id);
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(header.name),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Divider(),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _displayTaskInputDialog(
                                            context, header.id);
                                      },
                                      icon: Icon(Icons.add)),
                                ],
                              ),
                              children: <DragAndDropItem>[
                                for (var task in header.taskIdList)
                                  if (configState
                                          .tasks[configState.findIndexByID(
                                              configState.tasks, task)]
                                          .id ==
                                      task)
                                    DragAndDropItem(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 5.0),
                                        padding: const EdgeInsets.all(5.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.5)),
                                            border: Border.all(
                                                width: 0.5,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface)),
                                        child: Stack(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    configState
                                                        .tasks[configState
                                                            .findIndexByID(
                                                                configState
                                                                    .tasks,
                                                                task)]
                                                        .name,
                                                    softWrap: true),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () => {
                                                        print(configState
                                                            .tasks[configState
                                                                .findIndexByID(
                                                                    configState
                                                                        .tasks,
                                                                    task)]
                                                            .name)
                                                      },
                                                      icon: Icon(Icons
                                                          .keyboard_arrow_down_sharp),
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topLeft, child: CloseButton()),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: bookmarkIconSwitch(),
                    onPressed: () {
                      print('Toggle bookmark was activated');
                      configState.toggleFavBoard(widget.boardID);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (!_bookmarkSwitch) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added bookmark')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed bookmark')),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateBoardForm(
                                    boardID: widget.boardID,
                                    boardName: widget.boardName,
                                    boardDescription: widget.boardDescription,
                                  )),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.delete_outline_sharp),
                      onPressed: () {
                        showAlert(context);
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0, left: 65),
                        child: Text(
                          '#${widget.boardID}. ',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: Text(
                          widget.boardName,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
