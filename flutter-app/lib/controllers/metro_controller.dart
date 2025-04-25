import 'package:cairo_metro_flutter/core/algorithms/path_finder.dart';
import 'package:cairo_metro_flutter/core/algorithms/sorted_paths.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app/data/models/metro_path.dart';
import '../app/data/repositories/metro_repository.dart';
import '../core/algorithms/exchange_stations.dart';
import '../core/algorithms/ticket_service.dart';

class MetroController extends GetxController {
  MetroController({
    required this.currentLocation,
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
  final CurrentLocation currentLocation;
  final RxList<String> stationsNames = <String>[].obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  final selectedTransfers = 'Less Stations'.obs;
  final allPaths = <List<String>>[].obs;
  final allPathsByExchangedNum = <List<String>>[].obs;
  final metroPaths = <MetroPath>[].obs;
  final nearestStation = ''.obs;
  final distance = ''.obs;
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

  Future<void> getNearestStation(RxBool isNearStation) async {
    final location = await currentLocation.getCurrentLocation();
    if (isNearStation.value == true) {
      nearestStation.value = currentLocation
          .distanceBetweenStations(
            metroRepository.stations,
            location,
          )
          .station
          .name;
      // print('isNearStation${nearestStation.value}');
      startStation.value = nearestStation.value;
      return;
    }

    final stationLatLong = currentLocation
        .distanceBetweenStations(metroRepository.stations, location)
        .station
        .coordinates;
    final Uri url = Uri.parse(
      'geo:0,0?q=${stationLatLong[0]} ${stationLatLong[1]}',
    );
    // print("##########${nearestStation.value}");
    launchUrl(url);
  }

  Future<void> locationFromAddress(String address) async {
    final addressListOfLocation =
        await currentLocation.getAddressLatLong(address);

    final nearestStationByAddress = currentLocation.distanceBetweenStations(
        metroRepository.stations, addressListOfLocation);
    endStation.value = nearestStationByAddress.station.name;
    print("###########${endStation.value}");
  }

  @override
  void onClose() {
    startStation.value = '';
    endStation.value = '';
    super.onClose();
  }
}
