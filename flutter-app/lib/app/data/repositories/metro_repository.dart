import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/station.dart';

class MetroRepository {
  final List<MetroStation> stations = <MetroStation>[];
  final RxList<String> stationsNames = <String>[].obs;

  final lang = 'ar'.obs;

  Future<void> loadJsonData() async {
    final savedLang = GetStorage().read('language');
    if (savedLang != null) {
      lang.value = savedLang;
    } else {
      lang.value = Get.deviceLocale?.languageCode ?? 'ar';
    }
    stations.clear();
    stationsNames.clear();
    String jsonString =
        await rootBundle.loadString('assets/data_${lang.value}.json');
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
      if (station.name.trim() == stationName.trim()) {
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

  Future<void> updateLanguage(String languageCode) async {
    lang.value = languageCode;
    await loadJsonData();
  }
}
