import 'package:cairo_metro_flutter/screens/metro_home.dart';
import 'package:cairo_metro_flutter/screens/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/screens/route_details_portrait_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';

class MetroTripProgress extends StatelessWidget {
  const MetroTripProgress({super.key, required this.stations});

  final List<String> stations;

  @override
  Widget build(BuildContext context) {
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
            stations: stations,
            pathsCount: false,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MetroHome()),
                (Route<dynamic> route) => false,
              );
            },
            bigButtonName: 'Cancel',
          );
        } else {
          return RouteDetailsLandScapeScreen(
            stations: stations,
            pathsCount: false,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MetroHome()),
                (Route<dynamic> route) =>
                    false, // هذا يحذف جميع الصفحات السابقة
              );
            },
            bigButtonName: 'Cancel',
          );
        }
      }),
    );
  }
}
