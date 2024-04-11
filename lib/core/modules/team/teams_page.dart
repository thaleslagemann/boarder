import 'package:boarder/core/widgets/ui/shared/boarder_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => TeamsPageState();
}

class TeamsPageState extends State<TeamsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BoarderDrawer(),
      body: Center(
        child: Text('Teams'),
      ),
    );
  }
}
