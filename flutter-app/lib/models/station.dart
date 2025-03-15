class MetroStation {
  final String name;
  final Set<String> neighbors = {};

  MetroStation(this.name);

  void addNeighbor(String station) {
    neighbors.add(station);
  }
}
