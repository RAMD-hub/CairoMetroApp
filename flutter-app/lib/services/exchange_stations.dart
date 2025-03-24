import 'package:cairo_metro_flutter/models/station.dart';
import 'package:flutter/cupertino.dart';

import '../repositories/metro_repository.dart';

class ExchangeStation {
  final MetroRepository metroRepository;

  ExchangeStation({required this.metroRepository});

  List<String> getExchangeStations(final List<String> path) {
    final List<String> transferStations = [];
    int? currentLine;

    for (int i = 0; i < path.length - 1; i++) {
      final String stationName = path[i];
      final String nextStationName = path[i + 1];
      final List<int> stationLines =
          metroRepository.findStation(stationName).lineNumber;
      final List<int> nextStationLines =
          metroRepository.findStation(nextStationName).lineNumber;
      final int newLine = stationLines.firstWhere(
          (line) => nextStationLines.contains(line),
          orElse: () => -1);

      if (newLine != -1 && newLine != currentLine) {
        if (transferStations.isNotEmpty || i > 0) {
          transferStations.add(stationName);
        }
        currentLine = newLine;
      }
    }

    return transferStations;
  }
}
