import 'package:get/get.dart';
import '../app/data/repositories/metro_repository.dart';
import '../controllers/metro_controller.dart';
import '../core/algorithms/exchange_stations.dart';
import '../core/algorithms/path_finder.dart';
import '../core/algorithms/sorted_paths.dart';
import '../core/algorithms/ticket_service.dart';
import '../core/services/current_location.dart';

class MetroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PathFinder(metroRepository: Get.find()));
    Get.lazyPut(() => TicketService());
    Get.lazyPut(() => SortedPaths());
    Get.lazyPut(() => ExchangeStation(metroRepository: Get.find()));
    Get.lazyPut(() => MetroRepository());
    Get.lazyPut(() => CurrentLocation());
    Get.find<MetroRepository>().loadJsonData();
    Get.lazyPut(
      () => MetroController(
        pathFinder: Get.find(),
        ticketService: Get.find(),
        sortedPaths: Get.find(),
        exchangeStation: Get.find(),
        metroRepository: Get.find(),
        currentLocation: Get.find(),
      ),
    );
  }
}
