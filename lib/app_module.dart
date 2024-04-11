import 'package:boarder/app_settings/settings_page.dart';
import 'package:boarder/core/modules/board/boards_page.dart';
import 'package:boarder/core/modules/home_page/home_page.dart';
import 'package:boarder/core/modules/login_page/login_page.dart';
import 'package:boarder/core/modules/profile/profile_page.dart';
import 'package:boarder/core/modules/register_page/register_page.dart';
import 'package:boarder/core/modules/team/teams_page.dart';
import 'package:boarder/core/modules/user/user_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(UserController.new);
  }

  // initialRoute: '/',
  //       navigatorKey: navigatorKey,
  //       title: 'Boarder',
  //       theme: themeController.getCurrentTheme(),
  //       themeMode: themeController.getThemeMode(),
  //       home: userLoggedIn ? HomePage() : LoginPage(),

  @override
  void routes(r) {
    r.child('/', child: (context) => LoginPage());
    r.child('/login', child: (context) => LoginPage());
    r.child('/register', child: (context) => RegisterPage());
    r.child('/home', child: (context) => HomePage());
    r.child('/boards', child: (context) => BoardsPage());
    r.child('/profile', child: (context) => ProfilePage());
    r.child('/teams', child: (context) => TeamsPage());
    r.child('/settings', child: (context) => SettingsPage());
  }
}
