import '../models/metro_path.dart';

class SortedPaths {
  List<List<String>> sortMetroPathsByLengthOfStations(
      List<MetroPath> metroPaths) {
    metroPaths.sort((a, b) {
      if (a.path.length != b.path.length) {
        return a.path.length.compareTo(b.path.length);
      }
      return a.exchangedStationList.length
          .compareTo(b.exchangedStationList.length);
    });
    return metroPaths.map((e) => e.path).toList();
  }

  List<List<String>> sortMetroPathsByExchangeStations(
      List<MetroPath> metroPaths) {
    metroPaths.sort((a, b) {
      if (a.exchangedStationList.length != b.exchangedStationList.length) {
        return a.exchangedStationList.length
            .compareTo(b.exchangedStationList.length);
      }
      return a.path.length.compareTo(b.path.length);
    });

    return metroPaths.map((e) => e.path).toList();
  }
}
