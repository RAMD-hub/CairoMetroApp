import 'package:cairo_metro_flutter/screens/metro_routes.dart';
import 'package:cairo_metro_flutter/screens/metro_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MetroHome(),
    );
  }
}
