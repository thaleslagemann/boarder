import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  int _theme = 0;

  ThemeMode currentTheme() {
    switch (_theme) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void switchTheme(int value) {
    _theme = value;
    print('Changed system theme');
    notifyListeners();
  }
}
