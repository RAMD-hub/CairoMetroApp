import 'package:cairo_metro_flutter/screens/station_tile.dart';
import 'package:cairo_metro_flutter/services/exchange_stations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/metro_controller.dart';

class StationTileListView extends StatelessWidget {
  StationTileListView({
    super.key,
    required this.path,
    required this.pathIndex,
  });
  final int pathIndex;
  final List<String> path;
  final MetroController metroController = Get.put(MetroController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: path.length,
      itemBuilder: (context, index) {
        return StationTile(
          stationName: path[index],
          isFirst: index == 0,
          isLast: index == path.length - 1,
          isInterSection: exchangeStationInPath().contains(path[index]),
        );
      },
    );
  }

  List<String> exchangeStationInPath() {
    return metroController.exchangeStationsList[pathIndex].exchangedStationList;
  }
}
