import 'package:cairo_metro_flutter/app/modules/metro_home/views/metro_home.dart';
import 'package:cairo_metro_flutter/app/modules/metro_routes/views/metro_routes.dart';
import 'package:cairo_metro_flutter/app/modules/metro_trip_progress/views/metro_trip_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/metro_binding.dart';

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
      getPages: [
        GetPage(name: '/MetroHome', page: () => MetroHome()),
        GetPage(name: '/MetroRouteScreen', page: () => MetroRouteScreen()),
        GetPage(
          name: '/MetroTripProgress',
          page: () => MetroTripProgress(),
          transition: Transition.zoom,
        ),
      ],
    );
  }
}
