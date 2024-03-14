import 'package:boarder/app_settings/settings_page.dart';
import 'package:boarder/core/modules/board/boards_page.dart';
import 'package:boarder/core/modules/login_page/login_page.dart';
import 'package:boarder/core/modules/register_page/register_page.dart';
import 'package:boarder/core/themes/theme_controller.dart';
import 'package:boarder/core/modules/home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boarder/app_settings/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:boarder/app_settings/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:boarder/app_settings/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/modules/profile/profile_page.dart';
import 'core/modules/team/teams_page.dart';

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

  bool userLoggedIn = false;

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
      User? _user = FirebaseAuth.instance.currentUser;
      if (_user == null) {
        print('User is currently signed out!');
        userLoggedIn = false;
      } else {
        print('User is signed in!');
        userLoggedIn = true;
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
        theme: themeController.getCurrentTheme(),
        themeMode: themeController.getThemeMode(),
        home: userLoggedIn ? HomePage() : LoginPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => LoginPage());
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginPage());
            case '/register':
              return MaterialPageRoute(builder: (_) => RegisterPage());
            case '/boards':
              return MaterialPageRoute(builder: (_) => BoardsPage());
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case '/profile':
              return MaterialPageRoute(builder: (_) => ProfilePage());
            case '/teams':
              return MaterialPageRoute(builder: (_) => TeamsPage());
            case '/settings':
              return MaterialPageRoute(builder: (_) => SettingsPage());
            default:
              return MaterialPageRoute(builder: (_) => HomePage());
          }
        },
      ),
    );
  }
}
