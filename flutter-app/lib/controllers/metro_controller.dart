import 'package:cairo_metro_flutter/models/metro_path.dart';
import 'package:cairo_metro_flutter/repositories/metro_repository.dart';
import 'package:cairo_metro_flutter/services/path_finder.dart';
import 'package:cairo_metro_flutter/services/sorted_paths.dart';
import 'package:get/get.dart';
import '../services/audio_services.dart';
import '../services/exchange_stations.dart';
import '../services/ticket_service.dart';

class MetroController extends GetxController {
  MetroController({
    required this.pathFinder,
    required this.ticketService,
    required this.sortedPaths,
    required this.audioService,
    required this.exchangeStation,
    required this.metroRepository,
  });
  final ExchangeStation exchangeStation;
  final MetroRepository metroRepository;
  final TicketService ticketService;
  final PathFinder pathFinder;
  final SortedPaths sortedPaths;
  final AudioService audioService;
  final RxSet<String> stationsNames = <String>{}.obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  final selectedTransfers = 'Less Stations'.obs;
  final allPaths = <List<String>>[].obs;
  final allPathsByExchangedNum = <List<String>>[].obs;
  final metroPaths = <MetroPath>[].obs;
  @override
  void onInit() {
    super.onInit();
    stationsNames.assignAll(metroRepository.lines.expand((list) => list));
    everAll([startStation, endStation], (_) {
      findPaths();
    });
  }

  void findPaths() {
    if (startStation.value.isNotEmpty && endStation.value.isNotEmpty) {
      allPaths.assignAll(
        pathFinder.findAllPaths(startStation.value, endStation.value),
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

  void swapStations() {
    final temp = startStation.value;
    startStation.value = endStation.value;
    endStation.value = temp;
  }

  int getTicketPrice(int stationCount) {
    return ticketService.calculateTicketPrice(stationCount);
  }

  void playWelcomeUserInApp() {
    audioService.playSound();
  }

  void updateSelectedTransfer(String value) {
    selectedTransfers.value = value;
  }

  @override
  void onClose() {
    startStation.value = '';
    endStation.value = '';
    allPaths.clear();
    allPathsByExchangedNum.clear();
    metroPaths.clear();
    stationsNames.clear();
    audioService.dispose();
    super.onClose();
  }
}
