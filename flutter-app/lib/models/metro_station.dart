class MetroStation {
  final String name;
  final int line;
  final double? latitude;
  final double? longitude;

  MetroStation({
    required this.name,
    required this.line,
    this.latitude,
    this.longitude,
  });
}
