import 'package:flutter/material.dart';

class NewBoardForm extends StatelessWidget {
  var boardName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('New board name:'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a board name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
