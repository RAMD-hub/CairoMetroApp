import 'dart:ui';

import 'package:cairo_metro_flutter/core/algorithms/path_finder.dart';
import 'package:cairo_metro_flutter/core/algorithms/sorted_paths.dart';
import 'package:cairo_metro_flutter/core/services/location_service_background.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/data/models/metro_path.dart';
import '../../app/data/models/station.dart';
import '../../app/data/repositories/metro_repository.dart';
import '../algorithms/exchange_stations.dart';
import '../algorithms/ticket_service.dart';
import '../services/location_services.dart';

class MetroController extends GetxController {
  MetroController({
    required this.locationService,
    required this.pathFinder,
    required this.ticketService,
    required this.sortedPaths,
    required this.exchangeStation,
    required this.metroRepository,
  });

  final Rx<Locale> locale = Locale('en', '').obs;

  final RxBool tracking = false.obs;

  final ExchangeStation exchangeStation;
  final MetroRepository metroRepository;
  final TicketService ticketService;
  final PathFinder pathFinder;
  final SortedPaths sortedPaths;
  final LocationService locationService;
  final RxList<String> stationsNames = <String>[].obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  final selectedTransfers = 0.obs;
  final allPaths = <List<String>>[].obs;
  final allPathsByExchangedNum = <List<String>>[].obs;
  final userSelectedPath = <String>[].obs;
  final userSelectedPathToMetroStation = <MetroStation>[].obs;
  final metroPaths = <MetroPath>[].obs;
  final nearestStation = ''.obs;
  final currentStation = ''.obs;
  final distance = ''.obs;
  final getPaths =
      false.obs; // دا زي متغير كدا لما هعمله Listener لاستدعاء داله allPaths
  @override
  void onInit() {
    startStation.value = '';
    endStation.value = '';
    stationsNames.clear();
    allPaths.clear();
    allPathsByExchangedNum.clear();
    metroPaths.clear();

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
    final savedLang = GetStorage().read('language');
    if (savedLang != null) {
      locale.value = Locale(savedLang, '');
    }

    dynamic storedTrackingValue = GetStorage().read('tracking');
    tracking.value = storedTrackingValue is bool ? storedTrackingValue : false;
  }

  Future<void> changeLanguage(String languageCode) async {
    locale.value = Locale(languageCode, '');
    Get.updateLocale(locale.value);
    GetStorage().write('language', languageCode);
    await metroRepository.updateLanguage(languageCode);
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

  void updateSelectedTransfer(int value) {
    selectedTransfers.value = value;
  }

  Future<void> getNearestStation(RxBool isNearStation) async {
    final location = await locationService.getCurrentLocation();
    if (isNearStation.value == true) {
      nearestStation.value = locationService
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

    final stationLatLong = locationService
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
        await locationService.getAddressLatLong(address);

    final nearestStationByAddress = locationService.distanceBetweenStations(
        metroRepository.stations, addressListOfLocation);
    endStation.value = nearestStationByAddress.station.name;
  }

  void metroStationFromStationName() {
    userSelectedPathToMetroStation.clear();
    for (var stationName in userSelectedPath) {
      userSelectedPathToMetroStation.add(
        metroRepository.findStation(stationName),
      );
    }
  }

  void startTracking() {
    GetStorage().write('tracking', true);
    metroStationFromStationName();
    locationService.startTracking(userSelectedPathToMetroStation);
    ever(locationService.currentStation, (String stationName) {
      currentStation.value = stationName;
      print("MetroController currentStation updated to: $stationName");
    });
    tracking.value = true;
    if (locationService.currentStation.value.isNotEmpty) {
      currentStation.value = locationService.currentStation.value;
    }
  }

  void stopTracking() {
    tracking.value = false;
    GetStorage().write('tracking', false);
    locationService.stopTracking();
    LocationServiceBackground().stopLocationTracking();
  }

  bool positionStream() {
    return locationService.positionStream == null;
    // nullable => return true
    // nonNullable => return false
  }

  @override
  void onClose() {
    startStation.value = '';
    endStation.value = '';
    super.onClose();
  }
}
