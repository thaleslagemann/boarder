import 'package:flutter/material.dart';

class ReorderSettings with ChangeNotifier {
  int _reorder = 1;

  int currentReorderInt() {
    switch (_reorder) {
      case 0:
        return 0;
      case 1:
        return 1;
      default:
        return 0;
    }
  }

  String currentReorderString() {
    switch (_reorder) {
      case 0:
        return 'Insert';
      case 1:
        return 'Swap';
      default:
        return 'Insert';
    }
  }

  void switchReorder() {
    if (_reorder == 0) {
      _reorder = 1;
    } else {
      _reorder = 0;
    }
    print('Changed reorder type');
    print('Value $_reorder');
    notifyListeners();
  }
}
