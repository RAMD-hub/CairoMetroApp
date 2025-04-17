import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/station.dart';

class MetroRepository {
  final List<MetroStation> stations = [];
  final RxList<String> stationsNames = <String>[].obs;

  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    for (var item in jsonData) {
      stations.add(
        MetroStation(
          name: item['name'] ?? '',
          lineNumber: (item['lineNumber'] as List<dynamic>)
              .map((e) => e as int)
              .toList(),
          neighbors: (item['neighbors'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          coordinates: (item['coordinates'] as List<dynamic>)
              .map((e) => e as double)
              .toList(),
        ),
      );
      stationsNames.add(item['name']);
    }
  }

  MetroStation findStation(String stationName) {
    for (var station in stations) {
      if (station.name.trim().toLowerCase() ==
          stationName.trim().toLowerCase()) {
        return station;
      }
    }
    return MetroStation(
      name: 'Unknown Station',
      lineNumber: [-1],
      neighbors: [],
      coordinates: [],
    );
  }
}
