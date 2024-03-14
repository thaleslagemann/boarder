// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeController on ThemeControllerBase, Store {
  late final _$themeModeAtom =
      Atom(name: 'ThemeControllerBase.themeMode', context: context);

  @override
  String get themeMode {
    _$themeModeAtom.reportRead();
    return super.themeMode;
  }

  @override
  set themeMode(String value) {
    _$themeModeAtom.reportWrite(value, super.themeMode, () {
      super.themeMode = value;
    });
  }

  late final _$themeColorAtom =
      Atom(name: 'ThemeControllerBase.themeColor', context: context);

  @override
  Color get themeColor {
    _$themeColorAtom.reportRead();
    return super.themeColor;
  }

  @override
  set themeColor(Color value) {
    _$themeColorAtom.reportWrite(value, super.themeColor, () {
      super.themeColor = value;
    });
  }

  late final _$themeBrightnessAtom =
      Atom(name: 'ThemeControllerBase.themeBrightness', context: context);

  @override
  Brightness get themeBrightness {
    _$themeBrightnessAtom.reportRead();
    return super.themeBrightness;
  }

  @override
  set themeBrightness(Brightness value) {
    _$themeBrightnessAtom.reportWrite(value, super.themeBrightness, () {
      super.themeBrightness = value;
    });
  }

  late final _$ThemeControllerBaseActionController =
      ActionController(name: 'ThemeControllerBase', context: context);

  @override
  void setThemeMode(int mode) {
    final _$actionInfo = _$ThemeControllerBaseActionController.startAction(
        name: 'ThemeControllerBase.setThemeMode');
    try {
      return super.setThemeMode(mode);
    } finally {
      _$ThemeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setThemeColor(int color) {
    final _$actionInfo = _$ThemeControllerBaseActionController.startAction(
        name: 'ThemeControllerBase.setThemeColor');
    try {
      return super.setThemeColor(color);
    } finally {
      _$ThemeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  ThemeData getCurrentTheme() {
    final _$actionInfo = _$ThemeControllerBaseActionController.startAction(
        name: 'ThemeControllerBase.getCurrentTheme');
    try {
      return super.getCurrentTheme();
    } finally {
      _$ThemeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  ThemeMode getThemeMode() {
    final _$actionInfo = _$ThemeControllerBaseActionController.startAction(
        name: 'ThemeControllerBase.getThemeMode');
    try {
      return super.getThemeMode();
    } finally {
      _$ThemeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
themeMode: ${themeMode},
themeColor: ${themeColor},
themeBrightness: ${themeBrightness}
    ''';
  }
}
