import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/Views/map_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Map App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MapView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
