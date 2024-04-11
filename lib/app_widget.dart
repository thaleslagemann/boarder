import 'package:boarder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Boarder',
      themeMode: themeController.getThemeMode(),
      theme: themeController.getCurrentTheme(),
      routerConfig: Modular.routerConfig,
    );
  }
}
