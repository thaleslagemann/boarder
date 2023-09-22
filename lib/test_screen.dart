import 'package:flutter/material.dart';
import 'package:kanban_flt/test_board_view.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BasicExample(),
    ));
  }
}
