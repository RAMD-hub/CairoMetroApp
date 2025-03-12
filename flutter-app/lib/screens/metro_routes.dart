import 'package:cairo_metro_flutter/screens/metro_trip_progress.dart';
import 'package:cairo_metro_flutter/screens/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/screens/route_details_portrait_screen.dart';
import 'package:cairo_metro_flutter/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../widgets/custom_details_card.dart';
import '../widgets/custom_text.dart';
import '../widgets/station_tile_list_view.dart';

class MetroRouteScreen extends StatelessWidget {
  MetroRouteScreen({super.key});
  final List<String> stations = [
    "helwan (start)",
    "ain helwan",
    "helwan university",
    "wadi hof",
    "hadayek helwan",
    "el maasraa (changed)",
    "el maasraa",
    "el maasraa",
    "el maasraa",
    "el maasraa",
    "el maasraa (end)",
  ];

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MetroTripProgress(
                    stations: stations,
                  ),
                ),
              );
            },
            bigButtonName: 'Next',
          );
        } else {
          return RouteDetailsLandScapeScreen(
            stations: stations,
            onPressedBigNext: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MetroTripProgress(
                    stations: stations,
                  ),
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
