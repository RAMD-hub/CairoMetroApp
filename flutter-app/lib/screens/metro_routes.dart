import 'package:cairo_metro_flutter/screens/metro_trip_progress.dart';
import 'package:cairo_metro_flutter/screens/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/screens/route_details_portrait_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';

class MetroRouteScreen extends StatelessWidget {
  MetroRouteScreen({super.key});
  final pathIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final RxList<List<String>> paths = Get.arguments;
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
          return Obx(() {
            return RouteDetailsPortraitScreen(
              pathIndex: pathIndex.value,
              paths: paths,
              onPressedBigNext: () {
                Get.to(
                  MetroTripProgress(),
                  arguments: paths,
                );
              },
              bigButtonName: 'Next',
              onPressedCounterNext: () =>
                  pathIndex.value < paths.length - 1 ? pathIndex.value++ : null,
              onPressedCounterBack: () =>
                  pathIndex.value > 0 ? pathIndex.value-- : null,
            );
          });
        } else {
          return Obx(() {
            return RouteDetailsLandScapeScreen(
              pathIndex: pathIndex.value,
              paths: paths,
              onPressedBigNext: () {
                Get.to(
                  MetroTripProgress(),
                  arguments: paths,
                );
              },
              bigButtonName: 'Next',
              onPressedCounterNext: () =>
                  pathIndex.value < paths.length ? pathIndex.value++ : null,
              onPressedCounterBack: () =>
                  pathIndex.value > 0 ? pathIndex.value-- : null,
            );
          });
        }
      }),
    );
  }
}
