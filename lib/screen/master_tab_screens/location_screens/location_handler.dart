import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class LocationHandler {
  // Check and request location permissions
  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      MTAToast().ShowToast(
          'Location services are disabled. Please enable the services');
      return false;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        MTAToast().ShowToast('Location permissions are denied');
        return false;
      }
    }

    // Check if permanently denied
    if (permission == LocationPermission.deniedForever) {
      MTAToast().ShowToast(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }

    return true;
  }

  // Get current location with proper error handling
  static Future<Location?> getCurrentLocationWithValidation(BuildContext context) async {
    try {
      // First check permissions
      final hasPermission = await handleLocationPermission(context);
      if (!hasPermission) return null;

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      if (position != null) {
        return Location(
          latitude: position.latitude,
          longitude: position.longitude,
          // Set default distance if needed
          distance: 100.0, // Default 100 meters radius
        );
      }

      MTAToast().ShowToast('Failed to get location data');
      return null;
    } catch (e) {
      MTAToast().ShowToast('Error getting location: ${e.toString()}');
      return null;
    }
  }
}