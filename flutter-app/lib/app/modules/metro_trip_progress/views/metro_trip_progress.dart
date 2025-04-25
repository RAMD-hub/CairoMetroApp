import 'package:cairo_metro_flutter/app/shared/widgets/routes/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/app/shared/widgets/routes/route_details_portrait_screen.dart';
import 'package:cairo_metro_flutter/controllers/metro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MetroTripProgress extends StatefulWidget {
  const MetroTripProgress({super.key});

  @override
  State<MetroTripProgress> createState() => _MetroTripProgressState();
}

class _MetroTripProgressState extends State<MetroTripProgress> {
  final List<List<String>> path = Get.arguments;
  final MetroController metroController = Get.find();
  @override
  void initState() {
    super.initState();
    metroController.userSelectedPath.assignAll(path[0]);
    metroController.startTracking();
  }

  @override
  Widget build(BuildContext context) {
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
