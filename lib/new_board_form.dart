import 'package:flutter/material.dart';
import 'package:kanban_flt/config.dart';
import 'package:provider/provider.dart';

class NewBoardForm extends StatefulWidget {
  const NewBoardForm({super.key});

  @override
  NewBoardFormState createState() {
    return NewBoardFormState();
  }
}

class NewBoardFormState extends State<NewBoardForm> {
  final _newBoardKey = GlobalKey<FormState>();
  final newBoardController = TextEditingController();

  @override
  void dispose() {
    newBoardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    var _newBoardName;

    return Form(
      key: _newBoardKey,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(alignment: Alignment.topRight, child: CloseButton()),
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft, child: Text('New board\'s name:')),
                        TextFormField(
                          autofocus: true,
                          controller: newBoardController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (String value){_newBoardName=value;},
                          onFieldSubmitted: (value) {
                            if (_newBoardKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Creating board')),
                                  );
                                  print('New Board Name: $_newBoardName');
                                  configState.addBoard(_newBoardName);
                                  Navigator.pop(context);
                                }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Align(
                            alignment: Alignment.centerLeft, 
                            child: ElevatedButton(
                              onPressed: () {
                                if (_newBoardKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Creating board')),
                                  );
                                  print('New Board Name: $_newBoardName');
                                  configState.addBoard(_newBoardName);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ),
                      ],
                    ),
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