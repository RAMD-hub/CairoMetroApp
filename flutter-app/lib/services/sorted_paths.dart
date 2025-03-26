import 'package:dartx/dartx.dart';

import '../models/metro_path.dart';

class SortedPaths {
  List<List<String>> sortMetroPathsByLengthOfStations(
      List<MetroPath> metroPaths) {
    return metroPaths
        .sortedBy((e) => e.path.length)
        .thenBy((e) => e.exchangedStationList.length)
        .map((e) => e.path)
        .toList();
  }

  List<List<String>> sortMetroPathsByExchangeStations(
      List<MetroPath> metroPaths) {
    return metroPaths
        .sortedBy((e) => e.exchangedStationList.length)
        .thenBy((e) => e.path.length)
        .map((e) => e.path)
        .toList();
  }
}
