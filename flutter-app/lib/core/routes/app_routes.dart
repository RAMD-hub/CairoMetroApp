import 'package:get/get.dart';

import '../../app/modules/metro_home/views/metro_home.dart';
import '../../app/modules/metro_routes/views/metro_routes.dart';
import '../../app/modules/metro_trip_progress/views/metro_trip_progress.dart';
import '../../app/modules/onboarding/views/onboarding.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/MetroHome', page: () => MetroHome()),
    GetPage(name: '/MetroRouteScreen', page: () => MetroRouteScreen()),
    GetPage(
      name: '/MetroTripProgress',
      page: () => MetroTripProgress(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: '/Onboarding',
      page: () => OnboardingScreen(),
    ),
  ];
}
