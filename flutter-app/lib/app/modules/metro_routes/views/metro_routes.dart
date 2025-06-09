import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/helper/showCaseIsFirstTime.dart';
import '../widgets/route_details_landscape_screen.dart';
import '../widgets/route_details_portrait_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MetroRouteScreen extends StatefulWidget {
  const MetroRouteScreen({super.key});

  @override
  State<MetroRouteScreen> createState() => _MetroRouteScreenState();
}

class _MetroRouteScreenState extends State<MetroRouteScreen> {
  final pathIndex = 0.obs;
  final RxList<List<String>> paths = <List<String>>[].obs;
  final MetroController metroController = Get.find();
  final GlobalKey _startTripKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    showShowcaseIfFirstTime(
      context: context,
      keys: [_startTripKey],
      storageKey: 'hasShownShowcase_trip',
    );
    metroController.getPaths.value = true;
    paths.assignAll(metroController.selectedTransfers.value == 0
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
            onPressedBigNext: () async {
              metroController.userSelectedPath
                  .assignAll(paths[pathIndex.value]);
              GetStorage().write('path', paths[pathIndex.value]);
              Get.offNamed(
                '/MetroTripProgress',
              );
            },
            bigButtonName: AppLocalizations.of(context)!.startTrip,
            onPressedCounterNext: () =>
                pathIndex.value < paths.length - 1 ? pathIndex.value++ : null,
            onPressedCounterBack: () =>
                pathIndex.value > 0 ? pathIndex.value-- : null,
            startTripKey: _startTripKey,
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
            bigButtonName: AppLocalizations.of(context)!.startTrip,
            onPressedCounterNext: () =>
                pathIndex.value < paths.length - 1 ? pathIndex.value++ : null,
            onPressedCounterBack: () =>
                pathIndex.value > 0 ? pathIndex.value-- : null,
            startTripKey: _startTripKey,
          );
        }
      }),
    );
  }
}
