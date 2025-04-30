import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/data/models/address_latlong.dart';
import '../../app/data/models/nearest_station_result.dart';
import '../../app/data/models/station.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationService {
  Future<void> permissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notificationServiceTitle,
        AppLocalizations.of(Get.context!)!.locationServicesDisabled,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.notificationServiceTitle,
          AppLocalizations.of(Get.context!)!.locationPermissionsDenied,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        //  return null ;
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.notificationServiceTitle,
          AppLocalizations.of(Get.context!)!
              .locationPermissionsPermanentlyDenied,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // return null  ;
      }
    }
  }

  Future<AddressLatLong> getCurrentLocation() async {
    await permissions();
    final location = await Geolocator.getCurrentPosition();
    return AddressLatLong(lat: location.latitude, long: location.longitude);
  }

  NearestStationResult distanceBetweenStations(
      List<MetroStation> stations, AddressLatLong currentLocation) {
    double minDistance = double.infinity;
    MetroStation nearestStation = stations[0];
    for (var station in stations) {
      double distance = Geolocator.distanceBetween(currentLocation.lat,
          currentLocation.long, station.coordinates[0], station.coordinates[1]);
      if (distance < minDistance) {
        minDistance = distance;
        nearestStation = station;
      }
    }
    return NearestStationResult(nearestStation, minDistance);
  }

  Future<AddressLatLong> getAddressLatLong(String address) async {
    await permissions();
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.error,
          AppLocalizations.of(Get.context!)!.invalidAddress,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return AddressLatLong(
        lat: locations[0].latitude,
        long: locations[0].longitude,
      );
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.error,
        AppLocalizations.of(Get.context!)!.addressConversionError(e),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception("فشل في تحويل العنوان إلى إحداثيات: $e");
    }
  }

  final currentStation = ''.obs;
  final previousStation = ''.obs;
  final nextStation = ''.obs;
  bool isTracking = true; // used to enable tracking service

  StreamSubscription<Position>? positionStream;
  void startTracking(RxList<MetroStation> routeStations) async {
    if (!isTracking) return;
    GetStorage().write('tracking', true);
    await permissions();
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    if (currentStation.value.isNotEmpty) {
      currentStation.value = '';
    }
    final lastStation = routeStations.last;
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      double userLat = position.latitude;
      double userLng = position.longitude;

      for (var station in routeStations) {
        double distance = Geolocator.distanceBetween(
          userLat,
          userLng,
          station.coordinates[0],
          station.coordinates[1],
        );
        // print('Tracking On');
        if (distance <= 200) {
          //   print('قربت توصل لمحطة ${station.name}$distance');
          if (currentStation.value != station.name) {
            currentStation.value = station.name;
            final currentIndex =
                routeStations.indexWhere((s) => s.name == station.name);

            if (currentIndex != -1) {
              previousStation.value =
                  currentIndex > 0 ? routeStations[currentIndex - 1].name : '';

              nextStation.value = currentIndex < routeStations.length - 1
                  ? routeStations[currentIndex + 1].name
                  : '';
            }
          }
          if (station.name == lastStation.name) {
            // print("وصلت للمحطة الأخيرة: ${station.name}");
            GetStorage().write('tracking', false);
            stopTracking();
          }
          break;
        }
      }
    });
  }

  void stopTracking() {
    if (positionStream != null) {
      positionStream!.cancel();
      positionStream = null;
    }
    isTracking = false;
    GetStorage().write('tracking', false);
    // print("✅ تم إيقاف التتبع");
  }
}
