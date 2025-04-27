import 'package:cairo_metro_flutter/app/modules/metro_trip_progress/widgets/track_station_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/metro_controller.dart';

class TackingTileListView extends StatelessWidget {
  TackingTileListView({
    super.key,
    required this.path,
    required this.pathIndex,
  });
  final RxInt pathIndex;
  final RxList<String> path;
  final MetroController metroController = Get.find();
  final List<String> _exchangeStations = [];

  @override
  Widget build(BuildContext context) {
    _exchangeStations.assignAll(exchangeStationInPath());
    return ListView.builder(
      itemCount: path.length,
      itemBuilder: (context, index) {
        return TrackStationTile(
          stationName: path[index],
          isFirst: (index == 0).obs,
          isLast: (index == path.length - 1).obs,
          isInterSection: _exchangeStations.contains(path[index]).obs,
        );
      },
    );
  }

  List<String> exchangeStationInPath() {
    return metroController.exchangeStation.getExchangeStations(path);
  }
}
