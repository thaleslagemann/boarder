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

  String currentThemeString() {
    switch (_theme) {
      case 0:
        return 'System';
      case 1:
        return 'Light';
      case 2:
        return 'Dark';
      default:
        return 'System';
    }
  }

  void switchTheme(int value) {
    _theme = value;
    print('Changed system theme');
    print('Value $value');
    notifyListeners();
  }
}
