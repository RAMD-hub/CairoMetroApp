import 'package:cairo_metro_flutter/widgets/station_tile.dart';
import 'package:flutter/material.dart';

class StationTileListView extends StatelessWidget {
  const StationTileListView({
    super.key,
    required this.stations,
  });

  final List<String> stations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        return StationTile(
          stationName: stations[index],
          isFirst: index == 0,
          isLast: index == stations.length - 1,
          isInterSection: index == 5,
        );
      },
    );
  }
}
