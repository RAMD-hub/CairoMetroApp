import 'package:cairo_metro_flutter/repositories/metro_repository.dart';
import 'package:flutter/cupertino.dart';

class PathFinder {
  final MetroRepository metroRepository;
  PathFinder({required this.metroRepository});

  List<List<String>> findAllPaths(String start, String end) {
    if (metroRepository.findStation(start).name.isEmpty ||
        metroRepository.findStation(end).name.isEmpty) {
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
      final List<String> currentNeighbors =
          metroRepository.findStation(current).neighbors;
      debugPrint('$currentNeighbors  ✅✅✅ ');
      for (String neighbor in currentNeighbors) {
        if (!visited.contains(neighbor)) {
          _dfs(neighbor, end, path, visited, allPaths);
        }
      }
    }
    path.removeLast();
    visited.remove(current);
  }
}
