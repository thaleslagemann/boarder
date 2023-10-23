import 'package:firebase_core/firebase_core.dart';
import 'package:kanban_flt/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:kanban_flt/config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    globalAppTheme.addListener(() {
      print('And the theme changes!');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfigState(),
      child: MaterialApp(
        title: 'Kanban Flutter',
        theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: Colors.deepPurple,
            cardColor: Color.fromARGB(255, 255, 255, 255)),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.deepPurple,
            cardColor: Color.fromARGB(255, 30, 30, 30)),
        themeMode: globalAppTheme.currentTheme(),
        home: const AuthGate(),
      ),
    );
  }
}
