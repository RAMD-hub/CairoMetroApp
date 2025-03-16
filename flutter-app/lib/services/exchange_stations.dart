import 'package:dartx/dartx.dart';

import '../repositories/metro_repository.dart';

class ExchangeStation {
  final MetroRepository metroRepository = MetroRepository();

  List<String> getExchangeStations(final List<String> path) {
    final List<String> transferStations = [];
    int? currentLine;

    for (int i = 0; i < path.length - 1; i++) {
      String station = path[i];
      String nextStation = path[i + 1];

      List<int> stationLines = metroRepository.stations[station]!.lineNumber;
      List<int> nextStationLines =
          metroRepository.stations[nextStation]!.lineNumber;

      int newLine = stationLines.firstWhere(
          (line) => nextStationLines.contains(line),
          orElse: () => -1);

      if (newLine != -1 && newLine != currentLine) {
        if (transferStations.isNotEmpty || i > 0) {
          transferStations.add(station);
        }
        currentLine = newLine;
      }
    }

    return transferStations;
  }

  List<List<String>> sortPathsByExchanges(final List<List<String>> paths) {
    final ExchangeStation exchangeStation = ExchangeStation();
    return paths
        .sortedBy((path) => exchangeStation.getExchangeStations(path).length);
  }
}
