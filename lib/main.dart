import 'package:firebase_core/firebase_core.dart';
import 'package:boarder/app_settings/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:boarder/app_settings/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:boarder/app_settings/config.dart';

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
    taskShape.addListener(() {
      print('And the task shape changes!');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfigState(),
      child: MaterialApp(
        title: 'Boarder',
        theme: ThemeData(brightness: Brightness.light, colorSchemeSeed: Colors.deepPurple, cardColor: Color.fromARGB(255, 255, 255, 255)),
        darkTheme: ThemeData(brightness: Brightness.dark, colorSchemeSeed: Colors.deepPurple, cardColor: Color.fromARGB(255, 30, 30, 30)),
        themeMode: globalAppTheme.currentTheme(),
        home: const AuthGate(),
      ),
    );
  }
}
