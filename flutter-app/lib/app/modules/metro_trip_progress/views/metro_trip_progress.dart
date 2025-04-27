import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/metro_controller.dart';
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
  @override
  void initState() {
    super.initState();
    if (metroController.positionStream()) {
      Future.delayed(Duration.zero, () {
        metroController.startTracking();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> path = metroController.userSelectedPath;
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
          );
        }
      }),
    );
  }
}
