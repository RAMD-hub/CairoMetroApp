class MetroStation {
  final String name;
  final List<String> neighbors;
  final List<int> lineNumber;
  final List<double> coordinates;
  MetroStation({
    required this.name,
    required this.lineNumber,
    required this.neighbors,
    required this.coordinates,
  });
}
