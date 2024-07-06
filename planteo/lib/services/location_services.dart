import 'dart:developer';

import 'package:location/location.dart';
import 'package:planteo/controllers/location_controller.dart';
import 'package:planteo/utils/exports.dart';

class LocationServices {
  static Future getLocation() async {
    final controller = Get.put(LocationController());
    // LatLng? _currentLocation;
    // LatLng? _destinationLocation;

    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    double lat;
    double long;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        log('Location service is disabled');
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    log(locationData.toString());
    lat = locationData.latitude!;
    long = locationData.longitude!;
    controller.lat.value = lat.toString();
    controller.long.value = long.toString();
    // controller.sendLocation();
    log('Latitude: $lat, Longitude: $long');
    return locationData;
  }
}
