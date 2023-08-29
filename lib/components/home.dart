// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeModel {
  final count = 0.obs; // Use GetX's Observable to bind the count
  increment() => count.value++;
}

class HomeController extends GetxController {
  final model = HomeModel();

  increment() => model.increment();
}

class HomeView extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Count: ${controller.model.count.value}'),
            ElevatedButton(
              onPressed: controller.increment,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
