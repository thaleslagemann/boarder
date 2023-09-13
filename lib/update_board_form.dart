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
  final updateBoardController = TextEditingController();

  @override
  void dispose() {
    updateBoardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    var _updateBoardName;
    var currentBoardName = widget.boardName;
    String _boardDescription = widget.boardDescription;

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
                            child: Text('Board\'s new name:')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          autofocus: true,
                          controller: updateBoardController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value == currentBoardName) {
                              return 'Please choose a different name';
                            }
                            if (configState.boards[0].contains(value)) {
                              return 'Board called $value already exists.';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            _updateBoardName = value;
                          },
                          onFieldSubmitted: (value) {
                            if (_updateBoardKey.currentState!.validate()) {
                              print('Update Board Name: $_updateBoardName');
                              configState.updateBoard(
                                  currentBoardName, _updateBoardName);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

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
                                  configState.updateBoard(
                                      currentBoardName, _updateBoardName);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoardScreen(
                                            boardName: _updateBoardName,
                                            boardDescription:
                                                _boardDescription)),
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
