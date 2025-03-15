import 'package:get/get.dart';
import '../services/metro_service.dart';

class MetroController extends GetxController {
  final MetroService metroService = MetroService();
  final stationsNames = [];
  final startStation = ''.obs;
  final endStation = ''.obs;
  final paths = <List<String>>[].obs;
  @override
  void onInit() {
    super.onInit();
    stationsNames.addAll(metroService.lines.expand((list) => list).toList());
    everAll([startStation, endStation], (_) => findPaths());
  }

  void findPaths() {
    if (startStation.isNotEmpty && endStation.isNotEmpty) {
      paths.assignAll(
          metroService.findAllPaths(startStation.value, endStation.value));
    }
  }

  int calculateTicketPrice(int stationCount) {
    switch (stationCount) {
      case <= 9:
        return 8;
      case <= 16:
        return 10;
      case <= 23:
        return 15;
      default:
        return 20;
    }
  }
}
