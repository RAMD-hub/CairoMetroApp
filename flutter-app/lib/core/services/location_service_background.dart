import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_background/flutter_background.dart'
    as flutter_background;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/data/models/address_latlong.dart';

import '../../core/algorithms/exchange_stations.dart';
import '../../app/data/repositories/metro_repository.dart';
import '../services/location_services.dart';

class LocationServiceBackground {
  Timer? locationTimer;
  bool isInitialized = false;
  bool startTrip = false;
  String previousStation = '';

  late final ExchangeStation exchangeStation;
  late final MetroRepository metroRepository;
  late final LocationService locationService;

  Future<void> initialize() async {
    if (isInitialized) return;

    metroRepository = Get.find<MetroRepository>();
    exchangeStation = Get.find<ExchangeStation>();
    locationService = Get.find<LocationService>();

    await setupNotifications();

    isInitialized = true;
  }

  Future<void> setupNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/notification_icon',
      [
        NotificationChannel(
          channelKey: 'metro_location_channel',
          channelName: 'Metro Location Notifications',
          channelDescription: 'Notifies when near metro stations',
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Public,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          criticalAlerts: true,
        )
      ],
    );

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<bool> startLocationTracking() async {
    if (!isInitialized) {
      await initialize();
    }

    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle:
          AppLocalizations.of(Get.context!)!.notificationServiceTitle,
      notificationText:
          AppLocalizations.of(Get.context!)!.notificationServiceText,
      notificationImportance: AndroidNotificationImportance.high,
      notificationIcon: flutter_background.AndroidResource(
          name: 'notification_icon', defType: 'drawable'),
      enableWifiLock: true,
    );

    final backgroundInitialized =
        await FlutterBackground.initialize(androidConfig: androidConfig);

    if (backgroundInitialized) {
      if (!FlutterBackground.isBackgroundExecutionEnabled) {
        await FlutterBackground.enableBackgroundExecution();
      }
    }
    startTrip = false;
    checkLocation();
    startLocationUpdates();
    return true;
  }

  Future<void> stopLocationTracking() async {
    GetStorage().write('tracking', false);
    GetStorage().write('path', []);
    if (locationTimer != null) {
      locationTimer!.cancel();
      locationTimer = null;
    }

    startTrip = false;
    previousStation = '';

    if (FlutterBackground.isBackgroundExecutionEnabled) {
      await FlutterBackground.disableBackgroundExecution();
    }
  }

  void startLocationUpdates() {
    locationTimer?.cancel();
    locationTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => checkLocation());
  }

  Future<void> checkLocation() async {
    bool isTracking = GetStorage().read('tracking') ?? false;
    if (!isTracking) return;
    final currentLocation = await locationService.getCurrentLocation();
    print(
        'Current location obtained: ${currentLocation.lat}, ${currentLocation.long}');

    final path = GetStorage().read('path') ?? [];

    if (path.isEmpty) return;

    final nearestStationResult = locationService.distanceBetweenStations(
        metroRepository.stations, currentLocation);

    final nearestStation = nearestStationResult.station.name;
    final distance = nearestStationResult.distance;

    print('distance : $distance');
    if (nearestStation == path[0] && !startTrip && distance <= 1000) {
      startTrip = true;
      previousStation = nearestStation;

      await sendStationNotification(
          AppLocalizations.of(Get.context!)!.notificationStartTitle,
          AppLocalizations.of(Get.context!)!
              .notificationStartMessage(nearestStation),
          'start');
    }

    if (startTrip) {
      await findNearestStationAndNotify(currentLocation, path);
    }
  }

  Future<void> findNearestStationAndNotify(
      AddressLatLong currentLocation, List<String> path) async {
    final nearestStationResult = locationService.distanceBetweenStations(
        metroRepository.stations, currentLocation);

    final nearestStation = nearestStationResult.station.name;
    final distance = nearestStationResult.distance;

    print(
        'Checking station: $nearestStation, Previous: $previousStation, Distance: $distance');

    if (distance <= 1000 &&
        nearestStation.isNotEmpty &&
        previousStation != nearestStation &&
        path.contains(nearestStation)) {
      if ((path.contains(previousStation) &&
          path.indexOf(previousStation) < path.indexOf(nearestStation))) {
        await notifyForStation(nearestStation, path);
        previousStation = nearestStation;

        if (nearestStation == path.last) {
          await stopLocationTracking();
        }
      }
    }
  }

  Future<void> notifyForStation(String station, List<String> path) async {
    List<String> intersections = exchangeStation.getExchangeStations(path);

    if (station == path.last) {
      await sendStationNotification(
          AppLocalizations.of(Get.context!)!.notificationEndTitle,
          AppLocalizations.of(Get.context!)!.notificationEndMessage(station),
          'end');
    } else if (intersections.contains(station)) {
      await sendStationNotification(
          AppLocalizations.of(Get.context!)!.notificationIntersectionTitle,
          AppLocalizations.of(Get.context!)!
              .notificationIntersectionMessage(station),
          'change');
    }
  }

  Future<void> sendStationNotification(
      String title, String message, String type) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch % 100000;

    bool result = await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'metro_location_channel',
        title: title,
        body: message,
        notificationLayout: NotificationLayout.Default,
        icon: 'resource://drawable/notification_icon',
        category: NotificationCategory.Transport,
        color: Color(0xFFFEA613),
        wakeUpScreen: true,
        criticalAlert: true,
        autoDismissible: false, // Require user to dismiss
        displayOnBackground: true,
        displayOnForeground: true,
        locked: false,
      ),
    );
  }
}
