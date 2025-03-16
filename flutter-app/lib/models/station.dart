class MetroStation {
  final String name;
  final Set<String> neighbors = {};
  final List<int> lineNumber;
  MetroStation({required this.name, required this.lineNumber});

  void addNeighbor(String station) {
    neighbors.add(station);
  }
}
