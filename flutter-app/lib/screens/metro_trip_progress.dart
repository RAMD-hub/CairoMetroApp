import 'package:cairo_metro_flutter/screens/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/screens/route_details_portrait_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MetroTripProgress extends StatelessWidget {
  const MetroTripProgress({super.key});
  @override
  Widget build(BuildContext context) {
    final List<List<String>> path = Get.arguments;
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return RouteDetailsPortraitScreen(
            paths: path,
            isMetroRouteScreen: false,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              Get.offNamed('/MetroHome');
            },
            bigButtonName: 'Cancel',
          );
        } else {
          return RouteDetailsLandScapeScreen(
            paths: path,
            isMetroRouteScreen: false,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              Get.offNamed('/MetroHome');
            },
            bigButtonName: 'Cancel',
          );
        }
      }),
    );
  }
}
