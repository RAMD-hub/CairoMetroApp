import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/metro_binding.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MetroBinding(),
      initialRoute: '/MetroHome',
      getPages: AppRoutes.routes,
    );
  }
}
