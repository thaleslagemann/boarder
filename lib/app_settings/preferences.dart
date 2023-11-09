import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final String _kThemePrefs = "Theme Preferences";
  final String _kTaskShapePrefs = "Task Shape Preferences";

  Future<int> getThemePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_kThemePrefs) ?? 0;
  }

  Future<bool> setThemePreferences(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(_kThemePrefs, value);
  }

  Future<int> getTaskShapePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_kTaskShapePrefs) ?? 0;
  }

  Future<bool> setTaskShapePreferences(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(_kTaskShapePrefs, value);
  }
}
