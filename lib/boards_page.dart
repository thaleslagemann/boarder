import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kanban_flt/main.dart';

class BoardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.boardsList.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
            appState.addBoard();
          },
          child: Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: ListView(
        shrinkWrap: true,
        children: [
          for (var board in appState.boardsList)
            ListTile(
              onTap: appState.doSomething(),
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
          appState.addBoard();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
