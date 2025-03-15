import '../models/station.dart';

class MetroService {
  final Map<String, MetroStation> stations = {};
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

  MetroService() {
    _buildMetroGraph();
  }

  void _buildMetroGraph() {
    for (var line in lines) {
      for (int i = 0; i < line.length; i++) {
        stations.putIfAbsent(line[i], () => MetroStation(line[i]));
        if (i > 0) {
          stations[line[i]]!.addNeighbor(line[i - 1]);
          stations[line[i - 1]]!.addNeighbor(line[i]);
        }
      }
    }
  }

  List<List<String>> findAllPaths(String start, String end) {
    if (!stations.containsKey(start) || !stations.containsKey(end)) {
      return [];
    }
    List<List<String>> allPaths = [];
    _dfs(start, end, [], {}, allPaths);
    return allPaths;
  }

  void _dfs(String current, String end, List<String> path, Set<String> visited,
      List<List<String>> allPaths) {
    path.add(current);
    visited.add(current);

    if (current == end) {
      allPaths.add(List.from(path));
    } else {
      for (String neighbor in stations[current]!.neighbors) {
        if (!visited.contains(neighbor)) {
          _dfs(neighbor, end, path, visited, allPaths);
        }
      }
    }
    path.removeLast();
    visited.remove(current);
  }
}
