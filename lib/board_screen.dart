// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, unnecessary_string_interpolations

library config.globals;

// ignore_for_file: unused_field
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/db_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({
    super.key,
    required this.board,
  });

  final Board board;

  @override
  BoardScreenState createState() => BoardScreenState();
}

class BoardScreenState extends State<BoardScreen> {
  final TextEditingController _headerFieldController = TextEditingController();
  final TextEditingController _taskNameFieldController =
      TextEditingController();
  final TextEditingController _taskDescFieldController =
      TextEditingController();
  final TextEditingController _taskRenameFieldController =
      TextEditingController();
  final TextEditingController _headerRenameFieldController =
      TextEditingController();
  final TextEditingController _boardNameEditFieldController =
      TextEditingController();
  final TextEditingController _boardDescEditFieldController =
      TextEditingController();

  String boardNewName = '';
  String boardNewDesc = '';
  String newHeaderName = '';
  String newTaskName = '';
  String newTaskDesc = '';
  String renameHeaderNewName = '';
  String renameTaskNewName = '';

  int currentReorderOption = reorderType.currentReorderInt();

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

    _displayBoardDeletionAlert(BuildContext context, boardID) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            title: Text('Delete the board?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.inverseSurface),
                child: Text('cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  configState.databaseHelper.deleteBoard(boardID);
                  if (!configState.containsBoard(
                      configState.databaseHelper.boards, boardID)) {
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
            ],
          );
        },
      );
    }

    Future<void> _displayHeaderRenameDialog(
        BuildContext context, int headerID) async {
      _headerRenameFieldController.text = configState.databaseHelper
          .headers[configState.findHeaderIndexByID(headerID)].name;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
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
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.inverseSurface),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('ok'),
                  onPressed: () {
                    setState(() {
                      renameHeaderNewName = _headerRenameFieldController.text;
                      print(renameHeaderNewName);
                      configState.databaseHelper
                          .updateHeaderName(headerID, renameHeaderNewName);
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

    Future<void> _displayTaskRenameDialog(
        BuildContext context, Task task) async {
      _taskRenameFieldController.text = task.name;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              title: const Text('Rename task'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    renameTaskNewName = value;
                  });
                },
                autofocus: true,
                controller: _taskRenameFieldController,
                decoration: const InputDecoration(hintText: "New task name"),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.inverseSurface),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('ok'),
                  onPressed: () {
                    setState(() {
                      renameTaskNewName = _taskRenameFieldController.text;
                      print(renameTaskNewName);
                      configState.databaseHelper
                          .updateTaskName(task.taskId, renameTaskNewName);
                      Navigator.pop(context);
                      renameTaskNewName = '';
                      _taskRenameFieldController.clear();
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> _displayHeaderDeletionConfirmationDialog(
        BuildContext context, Header header) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              title: const Text('Delete header?'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.inverseSurface),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('delete'),
                  onPressed: () {
                    setState(() {
                      configState.databaseHelper.deleteHeader(header);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> _displayHeaderInputDialog(BuildContext context) async {
      String newHeaderName;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
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
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.inverseSurface),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('ok'),
                  onPressed: () {
                    setState(() {
                      newHeaderName = _headerFieldController.text;
                      print(newHeaderName);
                      final newHeader = Header(
                          headerId: configState.getSequentialHeaderID(0),
                          boardId: widget.board.boardId,
                          name: newHeaderName,
                          orderIndex: widget.board.headers.length,
                          tasks: []);
                      configState.databaseHelper.createHeader(newHeader);
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

    Future<void> _displayTaskDeletionConfirmationDialog(
        BuildContext context, Task task) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              title: const Text('Delete task?'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.inverseSurface),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('delete'),
                  onPressed: () {
                    setState(() {
                      configState.databaseHelper.deleteTask(task);
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              title: const Text('Create a new task'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newTaskName = value;
                    });
                  },
                  autofocus: true,
                  controller: _taskNameFieldController,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newTaskName = value;
                    });
                  },
                  autofocus: true,
                  controller: _taskDescFieldController,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
              ]),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.inverseSurface),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('ok'),
                  onPressed: () {
                    setState(() {
                      newTaskName = _taskNameFieldController.text;
                      newTaskDesc = _taskDescFieldController.text;
                      print("Creating new task: [$newTaskName]");
                      var taskID = configState.getSequentialTaskID(
                          configState.databaseHelper.tasks, 0);
                      var newTask = Task(
                        taskId: taskID,
                        headerId: headerID,
                        name: newTaskName,
                        description: newTaskDesc,
                        assignedUserId: 0,
                        orderIndex: configState
                            .databaseHelper
                            .headers[configState.findHeaderIndexByID(headerID)]
                            .tasks
                            .length,
                      );
                      configState.databaseHelper.createTask(newTask);
                      newTaskName = '';
                      newTaskDesc = '';
                      _taskNameFieldController.clear();
                      _taskDescFieldController.clear();
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> _displayBoardEditDialog(
        BuildContext context, Board board) async {
      _boardNameEditFieldController.text = board.name;
      _boardDescEditFieldController.text = board.description;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              title: const Text('Edit board'),
              content: 
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        boardNewName = value;
                      });
                    },
                    autofocus: true,
                    controller: _boardNameEditFieldController,
                    decoration: const InputDecoration(hintText: "Board name"),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        boardNewDesc = value;
                      });
                    },
                    autofocus: true,
                    controller: _boardDescEditFieldController,
                    decoration: const InputDecoration(hintText: "Board description"),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.inverseSurface),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('ok'),
                  onPressed: () {
                    setState(() {
                      boardNewName = _boardNameEditFieldController.text;
                      boardNewDesc = _boardDescEditFieldController.text;
                      print(boardNewName);
                      print(boardNewDesc);
                      configState.databaseHelper
                          .updateBoard(
                            Board(
                              boardId: board.boardId,
                              name: boardNewName,
                              description: boardNewDesc, 
                              creationDate: board.creationDate,
                              lastUpdate: DateTime.now()));
                      Navigator.pop(context);
                      boardNewName = '';
                      boardNewDesc = '';
                      _boardNameEditFieldController.clear();
                      _boardDescEditFieldController.clear();
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> _displayBoardDetailsDialog(
        BuildContext context, int boardID) async {
      var index = configState.findBoardIndexByID(boardID);
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              title: const Text('Board details'),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(text: 'ID: ', children: [
                            TextSpan(
                                text:
                                    '${configState.databaseHelper.boards[index].boardId}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(text: 'Name: ', children: [
                            TextSpan(
                                text:
                                    '${configState.databaseHelper.boards[index].name}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text.rich(
                            TextSpan(text: 'Description: ', children: [
                              TextSpan(
                                  text:
                                      '${configState.databaseHelper.boards[index].description}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(text: 'Creation date: ', children: [
                            TextSpan(
                                text:
                                    '${DateFormat('dd-MM-yyyy kk:mm').format(configState.databaseHelper.boards[index].creationDate)}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(text: 'Last update: ', children: [
                            TextSpan(
                                text:
                                    '${DateFormat('dd-MM-yyyy kk:mm').format(configState.databaseHelper.boards[index].lastUpdate)}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'ok',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface),
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> _displayTaskScreen(BuildContext context, Task task) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: Text("${task.name}"),
              content: Container(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    Text.rich(
                      TextSpan(
                        text:'ID: ',
                        style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.inverseSurface),
                        children: [
                          TextSpan(
                            text: '${task.taskId}',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                        ]),
                    ),
                    Text.rich(
                      TextSpan(
                        text:'Description: ',
                        style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.inverseSurface),
                        children: [
                          if(task.description != '')
                            TextSpan(
                              text: task.description,
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            ),
                          if(task.description == '')
                            TextSpan(
                              text: 'No description found.',
                              style: TextStyle(color: Theme.of(context).colorScheme.outline),
                            ),
                        ]),
                    ),
                    Text.rich(
                      TextSpan(
                        text:'Assigned User: ',
                        style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.inverseSurface),
                        children: [
                          TextSpan(
                            text: 'unimplemented',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                        ]),
                    )
                  ]
                ),
              )
          );
        }
      );
    }

    _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
        int newListIndex) {
      switch (currentReorderOption) {
        case 0:
          break;
        case 1:
          setState(() {
            if (true) {
            } else {}
            // int buffer = widget
            //     .board.headers[oldListIndex].tasks[oldItemIndex].orderIndex;
            // widget.board.headers[oldListIndex].tasks[oldItemIndex].orderIndex =
            //     widget
            //         .board.headers[newListIndex].tasks[newItemIndex].orderIndex;
            // widget.board.headers[newListIndex].tasks[newItemIndex].orderIndex =
            //     buffer;
            // configState.databaseHelper.sortHeadersAndTasks();
            print(
                '[${widget.board.headers[oldListIndex].headerId}, ${widget.board.headers[oldListIndex].tasks[oldItemIndex].orderIndex}] -> [${widget.board.headers[newListIndex].headerId}, ${widget.board.headers[newListIndex].tasks[newItemIndex].orderIndex}]');
          });
          break;
      }
      // int taskIndex = configState.findTaskIndexByID(configState
      //     .databaseHelper.headers[oldListIndex].tasks[oldItemIndex].taskId);
      //int oldHeaderId = configState.databaseHelper.boards[].headerId;
      //int newHeaderId = configState.databaseHelper.tasks[taskIndex].headerId;

      // setState(() {
      //    configState.databaseHelper.updateTaskOrderInDatabase(
      //        configState.databaseHelper.tasks[taskIndex],
      //        configState.databaseHelper.headers[oldListIndex],
      //        configState.databaseHelper.headers[newListIndex],
      //        oldItemIndex,
      //        newItemIndex);
      //    var movedItem = configState.databaseHelper.headers[oldListIndex].tasks
      //        .removeAt(oldItemIndex);
      //    configState.databaseHelper.headers[newListIndex].tasks
      //        .insert(newItemIndex, movedItem);
      //   print(
      //       '[$oldItemIndex, $oldListIndex] -> [$newItemIndex, $newListIndex]');
      // });
    }

    _onListReorder(int oldListIndex, int newListIndex) {
      setState(() {
        switch (reorderType.currentReorderInt()) {
          case 0:
            break;
          case 1:
            setState(() {
              Header buffer = widget.board.headers[newListIndex];
              widget.board.headers[newListIndex] =
                  widget.board.headers[oldListIndex];
              widget.board.headers[oldListIndex] = buffer;
            });
            break;
        }
        // var movedList = widget.board.headers.removeAt(oldListIndex);
        // widget.board.headers.insert(newListIndex, movedList);
      });
    }

    void headerChoiceAction(String choice, Header header) {
      if (choice == Constants.Delete) {
        print(
            'Removing header ${configState.databaseHelper.headers[configState.findHeaderIndexByID(header.headerId)].name}');
        _displayHeaderDeletionConfirmationDialog(context, header);
      } else if (choice == Constants.Rename) {
        _displayHeaderRenameDialog(context, header.headerId);
      } else if (choice == Constants.AddTask) {
        _displayTaskInputDialog(context, header.headerId);
      }
    }

    void taskChoiceAction(String choice, Task task) {
      if (choice == Constants.Delete) {
        print('Removing task ${task.name}');
        _displayTaskDeletionConfirmationDialog(context, task);
      } else if (choice == Constants.Rename) {
        _displayTaskRenameDialog(context, task);
      }
    }

    IconData choiceIcon(String choice) {
      if (choice == 'Delete') {
        return Icons.delete_outline_sharp;
      } else if (choice == 'Edit') {
        return Icons.edit_outlined;
      } else if (choice == 'Details') {
        return Icons.info_outlined;
      }
      return Icons.not_interested_outlined;
    }

    void boardChoiceAction(String choice, Board board) {
      if (choice == Constants.Delete) {
        _displayBoardDeletionAlert(context, board.boardId);
      } else if (choice == Constants.Edit) {
        _displayBoardEditDialog(context, board);
      } else if (choice == Constants.Details) {
        _displayBoardDetailsDialog(context, board.boardId);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                        listDragHandle: DragHandle(
                          verticalAlignment: DragHandleVerticalAlignment.top,
                          child: Icon(Icons.drag_handle),
                        ),
                        children: [
                          for (var header in widget.board.headers)
                            DragAndDropList(
                              contentsWhenEmpty: Text('Empty header'),
                              header: Padding(
                                padding: const EdgeInsets.only(right: 45.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert_sharp),
                                      itemBuilder: (BuildContext context) {
                                        return Constants.headerChoices
                                            .map((String choice) {
                                          return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                              onTap: () => {
                                                    setState(() {
                                                      headerChoiceAction(
                                                          choice, header);
                                                    })
                                                  });
                                        }).toList();
                                      },
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(header.name),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              children: <DragAndDropItem>[
                                for (var task in header.tasks)
                                  // if (configState
                                  //     .databaseHelper
                                  //     .headers[configState
                                  //         .findHeaderIndexByID(header.headerId)]
                                  //     .tasks
                                  //     .contains(task))
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
                                                  .primary)),
                                      child: Stack(children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _displayTaskScreen(context, task);
                                            });
                                          },
                                          child: Row(
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
                                                        .databaseHelper
                                                        .tasks[configState
                                                            .findTaskIndexByID(
                                                                task.taskId)]
                                                        .name,
                                                    style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                                                    softWrap: true),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    PopupMenuButton<String>(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                      ),
                                                      icon: Icon(
                                                          Icons
                                                              .arrow_drop_down_sharp,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .primary),
                                                      itemBuilder:
                                                          (BuildContext context) {
                                                        return Constants
                                                            .taskChoices
                                                            .map((String choice) {
                                                          return PopupMenuItem<
                                                                  String>(
                                                              value: choice,
                                                              child: Text(choice),
                                                              onTap: () => {
                                                                    setState(() {
                                                                      taskChoiceAction(
                                                                          choice,
                                                                          task);
                                                                    })
                                                                  });
                                                        }).toList();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topLeft, child: CloseButton()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: Text(
                          configState
                              .databaseHelper
                              .boards[configState
                                  .findBoardIndexByID(widget.board.boardId)]
                              .name
                              .capitalizeFirst!,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert_sharp),
                      itemBuilder: (BuildContext context) {
                        return Constants.boardChoices.map((String choice) {
                          return PopupMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  Icon(choiceIcon(choice)),
                                  Text(' $choice'),
                                ],
                              ),
                              onTap: () => {
                                    setState(() {
                                      boardChoiceAction(
                                          choice, widget.board);
                                    })
                                  });
                        }).toList();
                      },
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
