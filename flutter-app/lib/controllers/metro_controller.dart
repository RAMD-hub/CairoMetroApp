import 'package:cairo_metro_flutter/repositories/metro_repository.dart';
import 'package:cairo_metro_flutter/services/path_finder.dart';
import 'package:get/get.dart';
import '../services/ticket_service.dart';

class MetroController extends GetxController {
  final MetroRepository metroRepository = MetroRepository();
  final RxList<String> stationsNames = <String>[].obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  final paths = <List<String>>[].obs;
  @override
  void onInit() {
    super.onInit();
    stationsNames
        .assignAll(metroRepository.lines.expand((list) => list).toList());
    everAll([startStation, endStation], (_) => findPaths());
  }

  void findPaths() {
    final PathFinder pathFinder = PathFinder(metroRepository: metroRepository);
    if (startStation.isNotEmpty && endStation.isNotEmpty) {
      paths.assignAll(
          pathFinder.findAllPaths(startStation.value, endStation.value));
    }
  }

  int getTicketPrice(int stationCount) {
    final TicketService ticketService = TicketService();
    return ticketService.calculateTicketPrice(stationCount);
  }
}
