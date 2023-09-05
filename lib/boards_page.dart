import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kanban_flt/config.dart';

class BoardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

    if (configState.boardsList.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Text('No boards yet.'),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          foregroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () {
            configState.addBoard();
          },
          child: Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        shrinkWrap: true,
        children: [
          for (var board in configState.boardsList)
            ListTile(
              onTap: configState.doSomething(),
              leading: Icon(Icons.description),
              title: Text(board.toString()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: () {
          configState.addBoard();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
