import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../widgets/route_details_landscape_screen.dart';
import '../widgets/route_details_portrait_screen.dart';

class MetroRouteScreen extends StatefulWidget {
  const MetroRouteScreen({super.key});

  @override
  State<MetroRouteScreen> createState() => _MetroRouteScreenState();
}

class _MetroRouteScreenState extends State<MetroRouteScreen> {
  final pathIndex = 0.obs;
  final RxList<List<String>> paths = <List<String>>[].obs;
  final MetroController metroController = Get.find();

  @override
  void initState() {
    super.initState();
    metroController.getPaths.value = true;
    paths.assignAll(metroController.selectedTransfers.value == 'Less Stations'
        ? metroController.allPaths
        : metroController.allPathsByExchangedNum);
    metroController.getPaths.value = false; // reset boolean
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return RouteDetailsPortraitScreen(
            pathIndex: pathIndex,
            paths: paths,
            onPressedBigNext: () {
              metroController.userSelectedPath
                  .assignAll(paths[pathIndex.value]);
              Get.offNamed(
                '/MetroTripProgress',
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
              metroController.userSelectedPath
                  .assignAll(paths[pathIndex.value]);
              Get.offNamed(
                '/MetroTripProgress',
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
