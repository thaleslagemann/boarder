import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class ThemeController {
  ThemeController({
    this.themeMode = 'system',
    this.themeColor,
  });

  String themeMode;
  Color? themeColor = Color.fromRGBO(85, 64, 191, 1);

  ThemeData light_theme = ThemeData();
  ThemeData dark_theme = ThemeData();
}
