import 'package:get/get.dart';

import '../../app/data/repositories/metro_repository.dart';
import '../algorithms/exchange_stations.dart';
import '../algorithms/path_finder.dart';
import '../algorithms/sorted_paths.dart';
import '../algorithms/ticket_service.dart';
import '../controllers/metro_controller.dart';
import '../services/location_services.dart';

class MetroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PathFinder(metroRepository: Get.find()));
    Get.lazyPut(() => TicketService());
    Get.lazyPut(() => SortedPaths());
    Get.lazyPut(() => ExchangeStation(metroRepository: Get.find()));
    Get.lazyPut(() => MetroRepository());
    Get.lazyPut(() => LocationService());
    Get.find<MetroRepository>().loadJsonData();
    Get.lazyPut(
      () => MetroController(
        pathFinder: Get.find(),
        ticketService: Get.find(),
        sortedPaths: Get.find(),
        exchangeStation: Get.find(),
        metroRepository: Get.find(),
        locationService: Get.find(),
      ),
    );
  }
}
