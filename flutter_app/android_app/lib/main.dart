import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/Views/map_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapView(),
    );
  }
}
