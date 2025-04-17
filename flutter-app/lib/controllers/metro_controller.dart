import 'package:cairo_metro_flutter/models/metro_path.dart';
import 'package:cairo_metro_flutter/repositories/metro_repository.dart';
import 'package:cairo_metro_flutter/services/path_finder.dart';
import 'package:cairo_metro_flutter/services/sorted_paths.dart';
import 'package:get/get.dart';
import '../services/exchange_stations.dart';
import '../services/ticket_service.dart';

class MetroController extends GetxController {
  MetroController({
    required this.pathFinder,
    required this.ticketService,
    required this.sortedPaths,
    required this.exchangeStation,
    required this.metroRepository,
  });
  final ExchangeStation exchangeStation;
  final MetroRepository metroRepository;
  final TicketService ticketService;
  final PathFinder pathFinder;
  final SortedPaths sortedPaths;
  final RxList<String> stationsNames = <String>[].obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  final selectedTransfers = 'Less Stations'.obs;
  final allPaths = <List<String>>[].obs;
  final allPathsByExchangedNum = <List<String>>[].obs;
  final metroPaths = <MetroPath>[].obs;
  final getPaths =
      false.obs; // دا زي متغير كدا لما هعمله Listener لاستدعاء داله allPaths
  @override
  void onInit() {
    super.onInit();
    ever(metroRepository.stationsNames, (_) {
      stationsNames.assignAll(metroRepository.stationsNames);
    });
    ever(getPaths, (_) {
      if (startStation.value.isNotEmpty &&
          endStation.value.isNotEmpty &&
          getPaths.value != false) {
        findPaths();
      }
    });
  }

  void findPaths() {
    if (startStation.value.isNotEmpty && endStation.value.isNotEmpty) {
      allPaths.assignAll(
        pathFinder.findAllPaths(
            startStation.value.toLowerCase(), endStation.value.toLowerCase()),
      );
    }
    // get pathIndex and path and exchange stations
    metroPaths.clear();
    for (int i = 0; i < allPaths.length; i++) {
      metroPaths.add(
        MetroPath(
          pathNum: i,
          path: allPaths[i],
          exchangedStationList: exchangeStation.getExchangeStations(
            allPaths[i],
          ),
        ),
      );
    }

    // get all paths sort by num of stations
    allPaths
        .assignAll(sortedPaths.sortMetroPathsByLengthOfStations(metroPaths));
    // get all paths based on num of exchange stations
    allPathsByExchangedNum
        .assignAll(sortedPaths.sortMetroPathsByExchangeStations(metroPaths));
  }

  int getTicketPrice(int stationCount) {
    return ticketService.calculateTicketPrice(stationCount);
  }

  void updateSelectedTransfer(String value) {
    selectedTransfers.value = value;
  }

  @override
  void onClose() {
    startStation.value = '';
    endStation.value = '';
    super.onClose();
  }
}
