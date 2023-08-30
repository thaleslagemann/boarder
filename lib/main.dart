import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Kanban Flutter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: appState.defineColorScheme()),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var current = WordPair.random();

  var boardsList = <String>[];
  final List<String> themeSettingsList = <String>['Light', 'Dark', 'System'];

  int? colorSchemeState = 0;

  updateColorScheme(int? value) {
    colorSchemeState = value;
    notifyListeners();
  }

  MaterialColor defineColorScheme() {
    switch (colorSchemeState) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.indigo;
      case 2:
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  addBoard() {
    boardsList.add(WordPair.random().toString());
    notifyListeners();
  }

  doSomething() {
    print('Button was clicked.');
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = BoardsPage();
        break;
      case 1:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.splitscreen_outlined),
                    label: Text('Boards'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

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

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    int _value = 42;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Theme'),
                  SizedBox(width: 10),
                  DropdownButton(
                    value: _value,
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Green'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Indigo'),
                      ),
                    ],
                    onChanged: (int? value) {
                      appState.updateColorScheme(value);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('System'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
