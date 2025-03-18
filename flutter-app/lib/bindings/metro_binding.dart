import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import '../services/audio_services.dart';
import '../services/exchange_stations.dart';
import '../services/path_finder.dart';
import '../services/sorted_paths.dart';
import '../services/ticket_service.dart';
import '../repositories/metro_repository.dart';

class MetroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MetroRepository());
    Get.lazyPut(() => PathFinder(metroRepository: Get.find()));
    Get.lazyPut(() => TicketService());
    Get.lazyPut(() => SortedPaths());
    Get.lazyPut(() => ExchangeStation());
    Get.lazyPut(() => AudioService());

    Get.put(
      MetroController(
        pathFinder: Get.find(),
        ticketService: Get.find(),
        sortedPaths: Get.find(),
        audioService: Get.find(),
        exchangeStation: Get.find(),
        metroRepository: Get.find(),
      ),
    );
  }
}
