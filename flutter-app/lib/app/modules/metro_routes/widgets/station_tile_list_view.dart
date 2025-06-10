import 'package:cairo_metro_flutter/app/modules/metro_routes/widgets/station_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/metro_controller.dart';

class StationTileListView extends StatelessWidget {
  StationTileListView({
    super.key,
    required this.path,
    required this.pathIndex,
    this.scrollController,
  });
  final RxInt pathIndex;
  final RxList<String> path;
  final MetroController metroController = Get.find();
  final List<String> _exchangeStations = [];
  final ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    _exchangeStations.assignAll(exchangeStationInPath());
    return ListView.builder(
      controller: scrollController,
      itemCount: path.length,
      itemBuilder: (context, index) {
        return StationTile(
          stationName: path[index],
          isFirst: index == 0,
          isLast: index == path.length - 1,
          isInterSection: _exchangeStations.contains(path[index]),
        );
      },
    );
  }

  List<String> exchangeStationInPath() {
    return metroController.exchangeStation.getExchangeStations(path);
  }
}
