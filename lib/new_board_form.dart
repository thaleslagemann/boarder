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
  final newBoardNameController = TextEditingController();
  final newBoardDescriptionController = TextEditingController();

  @override
  void dispose() {
    newBoardNameController.dispose();
    newBoardDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    String newBoardName = '';
    String newBoardDescription = '';

    return Form(
      key: _newBoardKey,
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
                              Text('Create a new board',
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
                            child: Text('New board\'s name:')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          controller: newBoardNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (configState.containsElement(
                                configState.boards, value)) {
                              return 'Board called $value already exists.';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            newBoardName = value;
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
                            child: Text('New board\'s description:')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          autofocus: true,
                          minLines: 1,
                          maxLines: 8,
                          controller: newBoardDescriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            newBoardDescription = value;
                          },
                          onFieldSubmitted: (value) {
                            if (_newBoardKey.currentState!.validate()) {
                              print('New Board Name: $newBoardName');
                              print('New Board Name: $newBoardDescription');
                              configState.addBoard(
                                  newBoardName, newBoardDescription);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Board created')),
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
                                if (_newBoardKey.currentState!.validate()) {
                                  print('New Board Name: $newBoardName');
                                  print('New Board Name: $newBoardDescription');
                                  configState.addBoard(
                                      newBoardName, newBoardDescription);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Board created')),
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
