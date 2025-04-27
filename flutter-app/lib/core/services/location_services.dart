import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../app/data/models/address_latlong.dart';
import '../../app/data/models/nearest_station_result.dart';
import '../../app/data/models/station.dart';

class LocationService {
  Future<void> permissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Metro Cairo ',
        'Location services are disabled.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Metro Cairo',
          'Location permissions are denied',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        //  return null ;
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Get.snackbar(
          'Metro Cairo',
          'Location permissions are permanently denied, we cannot request permissions.',
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
          'Error',
          'Invalid or non-existent address',
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
        'Error',
        'Failed to convert address to coordinates: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception("فشل في تحويل العنوان إلى إحداثيات: $e");
    }
  }

  final currentStation = ''.obs;
  bool isTracking = true; // used to enable tracking service
  StreamSubscription<Position>? positionStream;
  void startTracking(RxList<MetroStation> routeStations) async {
    if (!isTracking) return;
    await permissions();
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
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
        print('Tracking On');
        if (distance <= 200) {
          print('قربت توصل لمحطة ${station.name}$distance');
          if (currentStation.value != station.name) {
            currentStation.value = station.name;
          }
          if (station.name == lastStation.name) {
            print("وصلت للمحطة الأخيرة: ${station.name}");
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
    print("✅ تم إيقاف التتبع");
  }
}
