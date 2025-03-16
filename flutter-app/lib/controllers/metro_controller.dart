import 'package:cairo_metro_flutter/repositories/metro_repository.dart';
import 'package:cairo_metro_flutter/services/path_finder.dart';
import 'package:dartx/dartx.dart';
import 'package:get/get.dart';
import '../services/ticket_service.dart';

class MetroController extends GetxController {
  // Initializer List Constructor
  MetroController()
      : pathFinder = PathFinder(
          metroRepository: MetroRepository(),
        ),
        ticketService = TicketService();

  final MetroRepository metroRepository = MetroRepository();
  final TicketService ticketService;
  final PathFinder pathFinder;
  final RxSet<String> stationsNames = <String>{}.obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  final allPaths = <List<String>>[].obs;
  final shortPath = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    stationsNames
        .assignAll(metroRepository.lines.expand((list) => list).toList());
    everAll([startStation, endStation], (_) => findPaths());
  }

  void findPaths() {
    if (startStation.isNotEmpty && endStation.isNotEmpty) {
      allPaths.assignAll(
          pathFinder.findAllPaths(startStation.value, endStation.value));
      allPaths.sort((a, b) => a.length.compareTo(b.length));
      shortPath.assignAll(allPaths.first);
    }
  }

  int getTicketPrice(int stationCount) {
    return ticketService.calculateTicketPrice(stationCount);
  }
}
