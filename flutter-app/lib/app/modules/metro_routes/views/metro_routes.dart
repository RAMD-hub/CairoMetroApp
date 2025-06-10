import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/helper/scroll_helper.dart';
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
  final ScrollController _scrollController = ScrollController();
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            onPressedCounterNext: () {
              if (pathIndex.value < paths.length - 1) {
                pathIndex.value++;
                customScrollToTop(_scrollController);
              }
            },
            onPressedCounterBack: () {
              if (pathIndex.value > 0) {
                pathIndex.value--;
                customScrollToTop(_scrollController);
              }
            },
            startTripKey: _startTripKey,
            scrollController: _scrollController,
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
            onPressedCounterNext: () {
              if (pathIndex.value < paths.length - 1) {
                pathIndex.value++;
                customScrollToTop(_scrollController);
              }
            },
            onPressedCounterBack: () {
              if (pathIndex.value > 0) {
                pathIndex.value--;
                customScrollToTop(_scrollController);
              }
            },
            startTripKey: _startTripKey,
            scrollController: _scrollController,
          );
        }
      }),
    );
  }
}
