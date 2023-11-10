import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  int _theme = 0;
  int _mainColor = 0;
  bool _isDarkMode = WidgetsBinding.instance.renderView.flutterView.platformDispatcher.platformBrightness == Brightness.dark;

  ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color.fromRGBO(85, 64, 191, 1),
        onPrimary: Color.fromRGBO(3, 3, 3, 1),
        primaryContainer: Color.fromRGBO(136, 117, 230, 1),
        onPrimaryContainer: Color.fromRGBO(3, 3, 3, 1),
        secondary: Color.fromRGBO(144, 45, 71, 1),
        onSecondary: Color.fromRGBO(3, 3, 3, 1),
        secondaryContainer: Color.fromRGBO(187, 85, 112, 1),
        onSecondaryContainer: Color.fromRGBO(3, 3, 3, 1),
        tertiary: Color.fromRGBO(203, 117, 61, 1),
        onTertiary: Color.fromRGBO(3, 3, 3, 1),
        tertiaryContainer: Color.fromRGBO(255, 160, 87, 1),
        onTertiaryContainer: Color.fromRGBO(3, 3, 3, 1),
        error: Colors.red,
        onError: Color.fromRGBO(3, 3, 3, 1),
        errorContainer: Colors.red[900],
        onErrorContainer: Color.fromRGBO(3, 3, 3, 1),
        background: Color.fromRGBO(249, 251, 244, 1),
        onBackground: Color.fromRGBO(3, 3, 3, 1),
        surface: Color.fromRGBO(249, 251, 244, 1),
        onSurface: Color.fromRGBO(3, 3, 3, 1),
        surfaceVariant: Color.fromRGBO(252, 252, 252, 1),
        onSurfaceVariant: Color.fromRGBO(3, 3, 3, 1),
        outline: Colors.black,
      ));

  ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color.fromRGBO(136, 117, 230, 1),
        onPrimary: Color.fromRGBO(252, 252, 252, 1),
        primaryContainer: Color.fromRGBO(85, 64, 191, 1),
        onPrimaryContainer: Color.fromRGBO(252, 252, 252, 1),
        secondary: Color.fromRGBO(187, 85, 112, 1),
        onSecondary: Color.fromRGBO(252, 252, 252, 1),
        secondaryContainer: Color.fromRGBO(144, 45, 71, 1),
        onSecondaryContainer: Color.fromRGBO(252, 252, 252, 1),
        tertiary: Color.fromRGBO(255, 160, 87, 1),
        onTertiary: Color.fromRGBO(252, 252, 252, 1),
        tertiaryContainer: Color.fromRGBO(203, 117, 61, 1),
        onTertiaryContainer: Color.fromRGBO(252, 252, 252, 1),
        error: Colors.red,
        onError: Color.fromRGBO(252, 252, 252, 1),
        errorContainer: Colors.red[900],
        onErrorContainer: Color.fromRGBO(252, 252, 252, 1),
        background: Color.fromRGBO(19, 17, 18, 1),
        onBackground: Color.fromRGBO(252, 252, 252, 1),
        surface: Color.fromRGBO(19, 17, 18, 1),
        onSurface: Color.fromRGBO(252, 252, 252, 1),
        surfaceVariant: Color.fromRGBO(16, 16, 16, 1),
        onSurfaceVariant: Color.fromRGBO(252, 252, 252, 1),
        outline: Colors.black,
      ));

  Color? mainColorOption() {
    if (_theme == 0 || (_theme == 2 && _isDarkMode)) {
      switch (_mainColor) {
        case 0:
          return darkTheme.colorScheme.primary;
        case 1:
          return darkTheme.colorScheme.secondary;
        case 2:
          return darkTheme.colorScheme.tertiary;
        default:
          return darkTheme.colorScheme.primary;
      }
    } else {
      switch (_mainColor) {
        case 0:
          return lightTheme.colorScheme.primary;
        case 1:
          return lightTheme.colorScheme.secondary;
        case 2:
          return lightTheme.colorScheme.tertiary;
        default:
          return lightTheme.colorScheme.primary;
      }
    }
  }

  Color? mainColorContainerOption() {
    if (_theme == 0 || (_theme == 2 && _isDarkMode)) {
      print('is dark mode');
      switch (_mainColor) {
        case 0:
          return darkTheme.colorScheme.primaryContainer;
        case 1:
          return darkTheme.colorScheme.secondaryContainer;
        case 2:
          return darkTheme.colorScheme.tertiaryContainer;
        default:
          return darkTheme.colorScheme.primaryContainer;
      }
    } else {
      print('is light mode');
      switch (_mainColor) {
        case 0:
          return lightTheme.colorScheme.primaryContainer;
        case 1:
          return lightTheme.colorScheme.secondaryContainer;
        case 2:
          return lightTheme.colorScheme.tertiaryContainer;
        default:
          return lightTheme.colorScheme.primaryContainer;
      }
    }
  }

  int getCurrentMainColor() {
    return _mainColor;
  }

  void switchMainColor(int value) {
    _mainColor = value;
    print('Changed system theme main color');
    print('Value $value');
    notifyListeners();
  }

  int getCurrentMainColorContainer() {
    return _mainColor;
  }

  void loadInitialTheme(int value) {
    _theme = value;
  }

  void loadInitialMainColor(int value) {
    _mainColor = value;
  }

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
