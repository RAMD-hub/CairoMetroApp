import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import '../services/exchange_stations.dart';
import '../services/path_finder.dart';
import '../services/sorted_paths.dart';
import '../services/ticket_service.dart';
import '../repositories/metro_repository.dart';

class MetroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PathFinder(metroRepository: Get.find()));
    Get.lazyPut(() => TicketService());
    Get.lazyPut(() => SortedPaths());
    Get.lazyPut(() => ExchangeStation(metroRepository: Get.find()));
    Get.lazyPut(() => MetroRepository());
    Get.find<MetroRepository>().loadJsonData();
    Get.lazyPut(
      () => MetroController(
        pathFinder: Get.find(),
        ticketService: Get.find(),
        sortedPaths: Get.find(),
        exchangeStation: Get.find(),
        metroRepository: Get.find(),
      ),
    );
  }
}
