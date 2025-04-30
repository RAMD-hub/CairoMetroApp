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
    // First, initialize the repository
    Get.put(MetroRepository(), permanent: true);
    
    // Then initialize services that don't depend on other services
    Get.put(LocationService(), permanent: true);
    Get.put(TicketService(), permanent: true);
    Get.put(SortedPaths(), permanent: true);
    
    // Initialize services that depend on the repository
    Get.put(ExchangeStation(metroRepository: Get.find()), permanent: true);
    Get.put(PathFinder(metroRepository: Get.find()), permanent: true);
    
    // Load repository data
    Get.find<MetroRepository>().loadJsonData();
    
    // Finally, initialize the controller that depends on all other services
    Get.put(
      MetroController(
        pathFinder: Get.find(),
        ticketService: Get.find(),
        sortedPaths: Get.find(),
        exchangeStation: Get.find(),
        metroRepository: Get.find(),
        locationService: Get.find(),
      ),
      permanent: true,
    );
  }
}
