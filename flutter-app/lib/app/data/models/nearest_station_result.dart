import 'package:cairo_metro_flutter/app/data/models/station.dart';

class NearestStationResult {
  final MetroStation station;
  final double distance;

  NearestStationResult(this.station, this.distance);
}
