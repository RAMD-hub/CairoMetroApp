import 'package:cairo_metro_flutter/screens/route_details_landscape_screen.dart';
import 'package:cairo_metro_flutter/screens/route_details_portrait_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../controllers/metro_controller.dart';
import '../widgets/custom_text.dart';

class MetroRouteScreen extends StatefulWidget {
  const MetroRouteScreen({super.key});

  @override
  State<MetroRouteScreen> createState() => _MetroRouteScreenState();
}

class _MetroRouteScreenState extends State<MetroRouteScreen> {
  final pathIndex = 0.obs;
  final MetroController metroController = Get.find();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RxList<List<String>> paths = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'All routes',
          txtColor: kPrimaryColor,
          txtFontWeight: FontWeight.bold,
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return RouteDetailsPortraitScreen(
            pathIndex: pathIndex,
            paths: paths,
            onPressedBigNext: () {
              Get.toNamed(
                '/MetroTripProgress',
                arguments: [paths[pathIndex.value]],
              );
            },
            bigButtonName: 'Next',
            onPressedCounterNext: () =>
                pathIndex.value < paths.length - 1 ? pathIndex.value++ : null,
            onPressedCounterBack: () =>
                pathIndex.value > 0 ? pathIndex.value-- : null,
          );
        } else {
          return RouteDetailsLandScapeScreen(
            pathIndex: pathIndex,
            paths: paths,
            onPressedBigNext: () {
              Get.toNamed(
                '/MetroTripProgress',
                arguments: [paths[pathIndex.value]],
              );
            },
            bigButtonName: 'Next',
            onPressedCounterNext: () =>
                pathIndex.value < paths.length - 1 ? pathIndex.value++ : null,
            onPressedCounterBack: () =>
                pathIndex.value > 0 ? pathIndex.value-- : null,
          );
        }
      }),
    );
  }
}
