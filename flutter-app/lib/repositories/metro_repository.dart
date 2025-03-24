import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/station.dart';

class MetroRepository {
  final List<MetroStation> stations = [];
  final List<List<String>> lines = [
    [
      'new marg',
      'el marg',
      'ezbet el nakhl',
      'ain shams',
      'el matareyya',
      'helmeyet el zaitoun',
      'hadayeq el zaitoun',
      'saray el qobba',
      'hammamat el qobba',
      'kobri el qobba',
      'mansheiet el sadr',
      'el demerdash',
      'ghamra',
      'al shohadaa',
      'orabi',
      'nasser',
      'sadat',
      'saad zaghloul',
      'al sayeda zeinab',
      'el malek el saleh',
      'mar girgis',
      'el zahraa',
      'dar el salam',
      'hadayek el maadi',
      'maadi',
      'sakanat el maadi',
      'tora el balad',
      'kozzika',
      'tura el esmant',
      'el maasraa',
      'hadayek helwan',
      'wadi hof',
      'helwan university',
      'ain helwan',
      'helwan'
    ],
    [
      'shubra el khaimah',
      'koliet el zeraa',
      'mezallat',
      'khalafawy',
      'st. teresa',
      'rod el farag',
      'masarra',
      'al shohadaa',
      'ataba',
      'mohamed naguib',
      'sadat',
      'opera',
      'dokki',
      'el bohooth',
      'cairo university',
      'faisal',
      'giza',
      'omm el masryeen',
      'saqiyet makky',
      'el monib'
    ],
    [
      'adly mansour',
      'haykestep',
      'omar ibn el khattab',
      'qubaa',
      'hesham barakat',
      'el nozha',
      'nadi el shams',
      'alf maskan',
      'heliopolis square',
      'haroun',
      'al ahram',
      'koleyet el banat',
      'stadium',
      'fair zone',
      'abbasseya',
      'abdou pasha',
      'el geish',
      'bab el shaaria',
      'ataba',
      'nasser',
      'maspero',
      'safa hegazy',
      'kit kat',
      'sudan',
      'imbaba',
      'el bohy',
      'el qawmia',
      'ring road',
      'rod el farag corridor'
    ],
    [
      'kit kat',
      'tawfikia',
      'wadi el nile',
      'gamat el dowal',
      'boulak el dakrour',
      'cairo university'
    ],
  ];

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
    }
    print("Total Stations Loaded: ✅✅✅✅✅✅✅✅✅✅✅✅✅✅${stations.length}");
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
