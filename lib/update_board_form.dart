import 'package:flutter/material.dart';
import 'package:kanban_flt/board_screen.dart';
import 'package:kanban_flt/config.dart';
import 'package:provider/provider.dart';

class UpdateBoardForm extends StatefulWidget {
  const UpdateBoardForm(
      {super.key, required this.boardName, required this.boardDescription});

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
  void setExistingValues(boardName, boardDescription) {
    updateBoardNameController.text = boardName;
    updateBoardDescriptionController.text = boardDescription;
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    var _updateBoardName;
    var currentBoardName = widget.boardName;
    String _boardDescription = widget.boardDescription;
    var _newBoardDescription;

    setExistingValues(currentBoardName, _boardDescription);

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
                            child: Text('Board\'s name:')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          autofocus: true,
                          controller: updateBoardNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (configState.boards[0].contains(value) &&
                                value != currentBoardName) {
                              return 'Board called $value already exists.';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            _updateBoardName = value;
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
                            child: Text('Board\'s description:')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          autofocus: true,
                          controller: updateBoardDescriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            _newBoardDescription = value;
                          },
                          onFieldSubmitted: (value) {
                            if (_updateBoardKey.currentState!.validate()) {
                              print('Update Board Name: $_updateBoardName');
                              print('Update Board Name: $_newBoardDescription');
                              configState.updateBoard(currentBoardName,
                                  _updateBoardName, _newBoardDescription);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardScreen(
                                        boardName: _updateBoardName,
                                        boardDescription:
                                            _newBoardDescription)),
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
                                  print('Update Board Name: $_updateBoardName');
                                  print(
                                      'Update Board Name: $_newBoardDescription');
                                  configState.updateBoard(currentBoardName,
                                      _updateBoardName, _newBoardDescription);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoardScreen(
                                            boardName: _updateBoardName,
                                            boardDescription:
                                                _newBoardDescription)),
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
