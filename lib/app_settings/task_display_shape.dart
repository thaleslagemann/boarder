import 'package:flutter/material.dart';

class TaskDisplayShape with ChangeNotifier {
  int _currentShape = 0;
  late Color _borderColor;

  void setPrimaryBorderColor(BuildContext context) {
    _borderColor = Theme.of(context).colorScheme.primary;
    print(_borderColor);
  }

  void switchBorderColor(Color color) {
    _borderColor = color;
    notifyListeners();
  }

  int getCurrentShapeInt() {
    return _currentShape;
  }

  Color getCurrentColor() {
    return _borderColor;
  }

  BoxDecoration getCurrentTaskShape(BuildContext context) {
    switch (_currentShape) {
      case 0:
        return BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            border: Border.all(width: 1.5, color: _borderColor));
      case 1:
        return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(width: 1.5, color: _borderColor));
      case 2:
        return BoxDecoration(borderRadius: BorderRadius.all(Radius.zero), border: Border.all(width: 1.5, color: _borderColor));
      default:
        return BoxDecoration(borderRadius: BorderRadius.all(Radius.zero), border: Border.all(width: 1.5, color: _borderColor));
    }
  }

  void switchTaskShape(int type) {
    _currentShape = type;
    notifyListeners();
  }
}
