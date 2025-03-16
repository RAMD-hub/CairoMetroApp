import 'package:cairo_metro_flutter/screens/station_tile.dart';
import 'package:flutter/material.dart';

class StationTileListView extends StatelessWidget {
  const StationTileListView({
    super.key,
    required this.path,
  });

  final List<String> path;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: path.length,
      itemBuilder: (context, index) {
        return StationTile(
          stationName: path[index],
          isFirst: index == 0,
          isLast: index == path.length - 1,
          isInterSection: index == 5,
        );
      },
    );
  }
}
