import 'package:cairo_metro_flutter/screens/metro_home.dart';
import 'package:cairo_metro_flutter/screens/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/screens/route_details_portrait_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';

class MetroTripProgress extends StatelessWidget {
  const MetroTripProgress({super.key});
  @override
  Widget build(BuildContext context) {
    final List<List<String>> stations = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'station',
          txtColor: const Color(0xFFFEA613),
          txtFontWeight: FontWeight.bold,
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return RouteDetailsPortraitScreen(
            paths: stations,
            isMetroRouteScreen: false,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              Get.offAll(MetroHome());
            },
            bigButtonName: 'Cancel',
          );
        } else {
          return RouteDetailsLandScapeScreen(
            paths: stations,
            isMetroRouteScreen: false,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              Get.offAll(MetroHome());
            },
            bigButtonName: 'Cancel',
          );
        }
      }),
    );
  }
}
