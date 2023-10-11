import 'package:flutter/material.dart';
import 'package:kanban_flt/board_screen.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/db_handler.dart';
import 'package:provider/provider.dart';

class UpdateBoardForm extends StatefulWidget {
  const UpdateBoardForm(
      {super.key,
      required this.boardID,
      required this.boardName,
      required this.boardDescription});

  final int boardID;
  final String boardName;
  final String boardDescription;

  @override
  UpdateBoardFormState createState() {
    return UpdateBoardFormState();
  }
}

class UpdateBoardFormState extends State<UpdateBoardForm> {
  final _updateBoardKey = GlobalKey<FormState>();
  final updateBoardNameController = TextEditingController();
  final updateBoardDescriptionController = TextEditingController();

  @override
  void dispose() {
    updateBoardNameController.dispose();
    updateBoardDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    int boardID = widget.boardID;
    String newBoardName = widget.boardName;
    String newBoardDescription = widget.boardDescription;
    updateBoardNameController.text = newBoardName;
    updateBoardDescriptionController.text = newBoardDescription;

    return Form(
      key: _updateBoardKey,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [CloseButton()]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Update board',
                                  style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Name:')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          controller: updateBoardNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (configState.isElementUnique(newBoardName) &&
                                value != widget.boardName) {
                              return 'Board called $value already exists.';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            newBoardName = value;
                            updateBoardNameController.text = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Description:')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          autofocus: true,
                          minLines: 1,
                          maxLines: 8,
                          controller: updateBoardDescriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            newBoardDescription = value;
                            updateBoardDescriptionController.text = value;
                          },
                          onFieldSubmitted: (value) {
                            if (_updateBoardKey.currentState!.validate()) {
                              print('Update Board Name: $newBoardName');
                              print('Update Board Name: $newBoardDescription');
                              Navigator.pop(context);
                              Navigator.pop(context);
                              configState.databaseHelper.updateBoard(Board(
                                  boardId: widget.boardID,
                                  name: updateBoardNameController.text,
                                  description:
                                      updateBoardDescriptionController.text,
                                  creationDate: configState
                                      .databaseHelper
                                      .boards[configState.findIndexByID(
                                          configState.databaseHelper.boards,
                                          widget.boardID)]
                                      .creationDate,
                                  lastUpdate: DateTime.now()));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardScreen(
                                          board:
                                              configState.databaseHelper.boards[
                                                  configState.findIndexByID(
                                                      configState.databaseHelper
                                                          .boards,
                                                      boardID)],
                                        )),
                              );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Board updated')),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_updateBoardKey.currentState!.validate()) {
                                  print('Update Board Name: $newBoardName');
                                  print(
                                      'Update Board Description: $newBoardDescription');
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  configState.databaseHelper.updateBoard(Board(
                                      boardId: widget.boardID,
                                      name: updateBoardNameController.text,
                                      description:
                                          updateBoardDescriptionController.text,
                                      creationDate: configState
                                          .databaseHelper
                                          .boards[configState.findIndexByID(
                                              configState.databaseHelper.boards,
                                              widget.boardID)]
                                          .creationDate,
                                      lastUpdate: DateTime.now()));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoardScreen(
                                              board: configState
                                                      .databaseHelper.boards[
                                                  configState.findIndexByID(
                                                      configState.databaseHelper
                                                          .boards,
                                                      boardID)],
                                            )),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Board updated')),
                                  );
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
