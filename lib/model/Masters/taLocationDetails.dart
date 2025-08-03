
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:time_attendance/model/Masters/talocation.dart';
// import 'package:mta/Models/Masters/talocation.dart';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAGeoLocation.dart';
import '../../General/MTAResult.dart';
import '../../widgets/mtaToast.dart';

class TALocationDetails
{
  //ToDo:  code optimization pending
  //get Current geo location
  // Future<TALocation> GetCurrentLocation()async
  // {
  //   bool bResult=false;
  //   TALocation objLocationInfo ;
  //   try
  //   {
  //       Position  position= await  MTAGeoLocation().GetCurrentGeoPosition() ;
  //       objLocationInfo=await MTAGeoLocation().GetLocationInfoFromPosition(position);
  //   }on Exception catch(e)
  //   {
  //     objLocationInfo= new  TALocation();
  //     MTAToast().ShowToast(e.toString());

  //   }
  //   return objLocationInfo;
  // }

  Future<TALocation> GetCurrentLocation() async {
  TALocation objLocationInfo = TALocation();
  
  try {
    // 1. First check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      objLocationInfo.IsErrorFound = true;
      objLocationInfo.ErrorMessage = 'Location services are disabled. Please enable GPS';
      return objLocationInfo;
    }

    // 2. Check location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        objLocationInfo.IsErrorFound = true;
        objLocationInfo.ErrorMessage = 'Location permission denied';
        return objLocationInfo;
      }
    }

    // 3. Handle permanently denied permissions
    if (permission == LocationPermission.deniedForever) {
      objLocationInfo.IsErrorFound = true;
      objLocationInfo.ErrorMessage = 'Location permissions are permanently denied. Please enable them in settings';
      return objLocationInfo;
    }

    // 4. Get position with timeout and better accuracy
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10)
    );

    // 5. Set the location information
    objLocationInfo.Latitude = position.latitude;
    objLocationInfo.Longitude = position.longitude;
    objLocationInfo.IsErrorFound = false;
    
    return objLocationInfo;
  } catch (e) {
    objLocationInfo.IsErrorFound = true;
    objLocationInfo.ErrorMessage = 'Failed to get current location: ${e.toString()}';
    return objLocationInfo;
  }
}

 //get All Locations from Rest Api
  Future<List<TALocation>> GetAllTALocations(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<TALocation> lstTALocation = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_Location);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstTALocation = parseTALocations(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstTALocation = [];
      print('error caught: $e');
    }
    return lstTALocation;
  }

  List<TALocation> parseTALocations(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<TALocation>((json) => TALocation.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<TALocation> GetTALocationByLocationID(AuthLogin objAuthLogin,
      String strTALocationID, MTAResult objMTAResult) async {
    TALocation objTALocation = new TALocation();

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strTALocationID, ApiConstants.endpoint_Location);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objTALocation = TALocation.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objTALocation = new TALocation(); // not sure in dart
      print('error caught: $e');
    }
    return objTALocation;
  }

  Future<bool> Save(AuthLogin objAuthLogin, TALocation objTALocation,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strTALocationJson = jsonEncode(objTALocation);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strTALocationJson, ApiConstants.endpoint_Location);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Update(AuthLogin objAuthLogin, TALocation objTALocation,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strTALocationJson = jsonEncode(objTALocation);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strTALocationJson, ApiConstants.endpoint_Location);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Delete(AuthLogin objAuthLogin, String strTALocationID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      TALocation objTALocation = new TALocation();
      objTALocation.LocationID = strTALocationID;

      String strTALocationJson = jsonEncode(objTALocation);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strTALocationJson, ApiConstants.endpoint_Location);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }


}