import 'package:cairo_metro_flutter/repositories/metro_repository.dart';
import 'package:cairo_metro_flutter/services/path_finder.dart';
import 'package:get/get.dart';
import '../services/exchange_stations.dart';
import '../services/ticket_service.dart';

class MetroController extends GetxController {
  // Initializer List Constructor
  MetroController()
      : pathFinder = PathFinder(
          metroRepository: MetroRepository(),
        ),
        ticketService = TicketService(),
        exchangeStation = ExchangeStation();

  final ExchangeStation exchangeStation;
  final MetroRepository metroRepository = MetroRepository();
  final TicketService ticketService;
  final PathFinder pathFinder;
  final RxSet<String> stationsNames = <String>{}.obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  final allPaths = <List<String>>[].obs;
  final shortPath = <String>[].obs;
  final exchangeStationsList = <List<String>>[].obs;
  @override
  void onInit() {
    super.onInit();
    stationsNames
        .assignAll(metroRepository.lines.expand((list) => list).toList());
    everAll([startStation, endStation], (_) => findPaths());
  }

  void findPaths() {
    if (startStation.value.isNotEmpty && endStation.value.isNotEmpty) {
      allPaths.assignAll(
          pathFinder.findAllPaths(startStation.value, endStation.value));
      allPaths.sort((a, b) => a.length.compareTo(b.length));
      //get shortest path
      shortPath.assignAll(allPaths.first);

      //get all intersection station
      exchangeStationsList.clear(); // el marg => gamat el dowal
      for (int i = 0; i < allPaths.length; i++) {
        exchangeStationsList
            .add(exchangeStation.getExchangeStations(allPaths[i]));
      }
    }
  }

  int getTicketPrice(int stationCount) {
    return ticketService.calculateTicketPrice(stationCount);
  }
}
