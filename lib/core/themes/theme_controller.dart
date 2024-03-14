import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobx/mobx.dart';
import 'package:hexcolor/hexcolor.dart';

part 'theme_controller.g.dart';

class ThemeController = ThemeControllerBase with _$ThemeController;

abstract class ThemeControllerBase with Store {
  ThemeControllerBase({
    this.themeMode = 'system',
    this.themeColor = Colors.deepPurple,
  });

  @observable
  late ThemeData theme = getCurrentTheme();

  @observable
  String themeMode;

  @observable
  Color themeColor = HexColor('#5540bf');

  @observable
  Brightness themeBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;

  ColorScheme light_theme = ColorScheme(
    brightness: Brightness.light,
    primary: HexColor('#5540bf'),
    onPrimary: HexColor('#000000'),
    secondary: HexColor('#902d47'),
    onSecondary: HexColor('#000000'),
    tertiary: HexColor('#cb763d'),
    onTertiary: HexColor('#000000'),
    error: HexColor('#ff0000'),
    onError: HexColor('#000000'),
    background: HexColor('#eeeeee'),
    onBackground: HexColor('#000000'),
    surface: HexColor('#ffffff'),
    onSurface: HexColor('#000000'),
  );

  ColorScheme dark_theme = ColorScheme(
    brightness: Brightness.light,
    primary: HexColor('#5540bf'),
    onPrimary: HexColor('#000000'),
    secondary: HexColor('#902d47'),
    onSecondary: HexColor('#000000'),
    tertiary: HexColor('#cb763d'),
    onTertiary: HexColor('#000000'),
    error: HexColor('#ff0000'),
    onError: HexColor('#000000'),
    background: HexColor('#eeeeee'),
    onBackground: HexColor('#000000'),
    surface: HexColor('#ffffff'),
    onSurface: HexColor('#000000'),
  );

  @action
  void setThemeMode(int mode) {
    switch (mode) {
      case 0:
        themeMode = 'system';
        themeBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
        break;
      case 1:
        themeMode = 'light';
        themeBrightness = Brightness.light;
        break;
      case 2:
        themeMode = 'dark';
        themeBrightness = Brightness.dark;
        break;
    }
  }

  @action
  void setThemeColor(int color) {
    switch (color) {
      case 0:
        themeColor = HexColor('#5540bf');
        break;
      case 1:
        themeColor = HexColor('#902d47');
        break;
      case 2:
        themeColor = HexColor('#cb763d');
        break;
      case 3:
        themeColor = HexColor('#31dd2e');
    }
  }

  @action
  ThemeData getCurrentTheme() {
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
        selectionColor: themeBrightness == Brightness.dark ? HexColor('#80ffffff') : HexColor('#80000000'),
        selectionHandleColor: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
      ),
      colorScheme: ColorScheme(
        brightness: themeBrightness,
        primary: themeColor,
        onPrimary: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
        secondary: themeColor,
        onSecondary: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
        tertiary: themeColor,
        onTertiary: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
        error: HexColor('#bd0000'),
        onError: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
        background: themeBrightness == Brightness.dark ? HexColor('#050505') : HexColor('#eeeeee'),
        onBackground: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
        surface: themeBrightness == Brightness.dark ? HexColor('#111111') : HexColor('#ffffff'),
        onSurface: themeBrightness == Brightness.dark ? HexColor('#ffffff') : HexColor('#000000'),
      ),
    );
  }

  @action
  ThemeMode getThemeMode() {
    switch (themeMode) {
      case 'system':
        return ThemeMode.system;
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
