

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_attendance/model/Masters/talocation.dart';
// import 'package:geolocator/geolocator.dart';
// import '../Models/Masters/talocation.dart';
import '../widgets/mtaToast.dart';

class MTAGeoLocation
{

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  ///
  Future<Position> GetCurrentGeoPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      MTAToast().ShowToast('Location services are disabled.');
      Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        MTAToast().ShowToast('Location permissions are denied.');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      MTAToast().ShowToast('Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  Future<String> GetAddressFromPosition(Position currentPosition) async {

    String strAddress="";
    try {
      await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        strAddress ='${place.name},${place.street},${place.locality},${place.subAdministrativeArea},${place.administrativeArea},${place.country},${place.postalCode}';
      });
    }
    on Exception catch(e)
    {
      strAddress='';
      MTAToast().ShowToast(e.toString());
    }
    return strAddress;
  }


  Future<TALocation> GetLocationInfoFromPosition(Position currentPosition) async {

    TALocation objLocationInfo= TALocation();
    try {
      await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        objLocationInfo.LocationName=place.name.toString();

        String strAddress ='${place.street},\n${place.locality},\n${place.subAdministrativeArea},\n${place.administrativeArea},\n${place.country}, ${place.postalCode}';

        objLocationInfo.Address=strAddress;
        objLocationInfo.State=place.administrativeArea;
        objLocationInfo.City=place.locality; //Todo: check this
        objLocationInfo.Country=place.country;
        objLocationInfo.PostalCode=place.postalCode;
        objLocationInfo.Latitude=currentPosition.latitude.toString();
        objLocationInfo.Longitude=currentPosition.longitude.toString();
      });
    }
    on Exception catch(e)
    {
      objLocationInfo=TALocation();
      MTAToast().ShowToast(e.toString());
    }
    return objLocationInfo;
  }
}


