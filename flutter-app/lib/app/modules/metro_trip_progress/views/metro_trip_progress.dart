import 'package:cairo_metro_flutter/core/services/location_premissions.dart';
import 'package:cairo_metro_flutter/core/services/location_service_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/helper/showCaseIsFirstTime.dart';
import '../widgets/tracking_landscape_screen.dart';
import '../widgets/tracking_portrait_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MetroTripProgress extends StatefulWidget {
  const MetroTripProgress({super.key});

  @override
  State<MetroTripProgress> createState() => _MetroTripProgressState();
}

class _MetroTripProgressState extends State<MetroTripProgress> {
  final MetroController metroController = Get.find();
  final GlobalKey _cancelTripKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    showShowcaseIfFirstTime(
      context: context,
      keys: [_cancelTripKey],
      storageKey: 'hasShownShowcase_liveTracking',
    );
    if (metroController.positionStream()) {
      Future.delayed(Duration.zero, () async {
        metroController.startTracking();
        await Permissions().checkLocationPermission();
        await LocationServiceBackground().startLocationTracking();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> path = metroController.userSelectedPath;
    if (path.isEmpty && GetStorage().read('path') != null) {
      final dynamic storedPath = GetStorage().read('path');
      if (storedPath is List) {
        path = storedPath.map((item) => item.toString()).toList();
      }
    }
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return TrackingPortraitScreen(
            paths: path,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              metroController.stopTracking();
              Get.back();
            },
            bigButtonName: AppLocalizations.of(context)!.cancel,
            cancelTripKey: _cancelTripKey,
          );
        } else {
          return TrackingLandScapeScreen(
            paths: path,
            btnBackgroundColor: Colors.red,
            onPressedBigNext: () {
              metroController.stopTracking();
              Get.back();
            },
            bigButtonName: AppLocalizations.of(context)!.cancel,
            cancelTripKey: _cancelTripKey,
          );
        }
      }),
    );
  }
}
