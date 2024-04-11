import 'package:boarder/app_settings/config.dart';
import 'package:boarder/app_settings/setting_classes/preferences.dart';
import 'package:flutter/material.dart';

class TaskDisplayShape with ChangeNotifier {
  TaskDisplayShape() {
    getCurrentShapePreferences();
  }
  Preferences prefs = Preferences();

  late int _currentShape;
  Future<void> getCurrentShapePreferences() async {
    _currentShape = await prefs.getTaskShapePreferences();
  }

  int getCurrentShapeInt() {
    return _currentShape;
  }

  BoxDecoration getCurrentTaskShape(BuildContext context) {
    switch (_currentShape) {
      case 0:
        return BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            border: Border.all(width: 1.5, color: globalAppTheme.mainColorOption()!));
      case 1:
        return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(width: 1.5, color: globalAppTheme.mainColorOption()!));
      case 2:
        return BoxDecoration(borderRadius: BorderRadius.all(Radius.zero), border: Border.all(width: 1.5, color: globalAppTheme.mainColorOption()!));
      default:
        return BoxDecoration(borderRadius: BorderRadius.all(Radius.zero), border: Border.all(width: 1.5, color: globalAppTheme.mainColorOption()!));
    }
  }

  void switchTaskShape(int type) {
    _currentShape = type;
    notifyListeners();
  }
}
