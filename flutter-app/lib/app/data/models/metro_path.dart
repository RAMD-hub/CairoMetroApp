class MetroPath {
  final int pathNum;
  final List<String> path;
  final List<String> exchangedStationList;

  const MetroPath({
    required this.pathNum,
    required this.exchangedStationList,
    required this.path,
  });
}
