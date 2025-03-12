import 'package:cairo_metro_flutter/screens/metro_trip_progress.dart';
import 'package:cairo_metro_flutter/screens/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/screens/route_details_portrait_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';

class MetroRouteScreen extends StatelessWidget {
  const MetroRouteScreen({super.key, required this.stations});
  final List<String> stations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'All routes',
          txtColor: const Color(0xFFFEA613),
          txtFontWeight: FontWeight.bold,
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return RouteDetailsPortraitScreen(
            stations: stations,
            onPressedBigNext: () {
              Get.to(
                MetroTripProgress(
                  stations: stations,
                ),
              );
            },
            bigButtonName: 'Next',
          );
        } else {
          return RouteDetailsLandScapeScreen(
            stations: stations,
            onPressedBigNext: () {
              Get.to(
                MetroTripProgress(
                  stations: stations,
                ),
              );
            },
            bigButtonName: 'Next',
          );
        }
      }),
    );
  }
}
