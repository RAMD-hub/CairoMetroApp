import 'package:cairo_metro_flutter/models/exchanges_stations_model.dart';
import 'package:cairo_metro_flutter/repositories/metro_repository.dart';
import 'package:cairo_metro_flutter/services/path_finder.dart';
import 'package:get/get.dart';
import '../services/exchange_stations.dart';
import '../services/ticket_service.dart';

class MetroController extends GetxController {
  // Initializer List Constructor // بدلا من وضع القيم بايدي كل مره هو بيستدعيهم تلقائيا
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
  final exchangeStationsList = <exchangedStationModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    stationsNames
        .assignAll(metroRepository.lines.expand((list) => list).toList());
    everAll([startStation, endStation], (_) => findPaths());
    exchangeStationsList;
  }

  void findPaths() {
    if (startStation.value.isNotEmpty && endStation.value.isNotEmpty) {
      allPaths.assignAll(
        pathFinder.findAllPaths(startStation.value, endStation.value),
      );
      allPaths.sort((a, b) => a.length.compareTo(b.length));

      //get shortest path => based on Stations Number
      shortPath.assignAll(allPaths.first);

      //get shortest path => based on number of exchange

      //get all intersection station
      exchangeStationsList.clear();
      for (int i = 0; i < allPaths.length; i++) {
        exchangeStationsList.add(
          exchangedStationModel(
            path: i,
            exchangedStationList: exchangeStation.getExchangeStations(
              allPaths[i],
            ),
          ),
        );
      }
    }
  }

  int getTicketPrice(int stationCount) {
    return ticketService.calculateTicketPrice(stationCount);
  }
}
