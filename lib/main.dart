import 'package:boarder/app_settings/setting_classes/login_page/login_page.dart';
import 'package:boarder/app_settings/setting_classes/register_page/register_page.dart';
import 'package:boarder/core/themes/theme_controller.dart';
import 'package:boarder/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boarder/app_settings/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:boarder/app_settings/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:boarder/app_settings/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final themeController = ThemeController();

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
  late SharedPreferences prefs;
  late int? _initialTheme;
  late int? _initialMainColor;
  final String _kThemePrefs = "Theme Preferences";
  final String _kMainColorPrefs = "Main Color Preferences";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      prefs = sp;
      _initialMainColor = prefs.getInt(_kMainColorPrefs);
      _initialTheme = prefs.getInt(_kThemePrefs);
      if (_initialMainColor == null) {
        _initialMainColor = 0;
        themeController.setThemeColor(_initialMainColor!);
      } else {
        themeController.setThemeColor(_initialMainColor!);
      }
      if (_initialTheme == null) {
        _initialTheme = 0;
        themeController.setThemeMode(_initialTheme!);
      } else {
        themeController.setThemeMode(_initialTheme!);
      }
      setState(() {});
    });

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
        initialRoute: '/',
        navigatorKey: navigatorKey,
        title: 'Boarder',
        theme: globalAppTheme.lightTheme,
        darkTheme: globalAppTheme.darkTheme,
        themeMode: globalAppTheme.currentTheme(),
        home: const LoginPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => LoginPage());
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginPage());
            case '/register':
              return MaterialPageRoute(builder: (_) => RegisterPage());
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            default:
              return MaterialPageRoute(builder: (_) => HomePage());
          }
        },
      ),
    );
  }
}
