import 'dart:convert';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'Shift.dart';


class ShiftDetails {
//ToDo:  code optimization pending
  Future<List<Shift>> GetAllShiftes(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<Shift> lstShift = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_Shift);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstShift = parseShifts(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstShift = [];
      print('error caught: $e');
    }
    return lstShift;
  }
  
  Future<Shift?> GetDefaultShift(AuthLogin objAuthLogin, MTAResult objMTAResult) async {
    Shift? objShift;
    try {
      // Use a custom endpoint for GetDefaultShift
      Result objResult = await APIInteraction().GetAllObjects(
        objAuthLogin, 
        ApiConstants.endpoint_Shift + "/GetDefaultShift"
      );
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass && !objResult.IsMultipleRecordsInJson) {
        // The API returns a JSON string inside ResultRecordJson
        String strJson = objResult.ResultRecordJson;
        // If the response is a stringified JSON object, decode twice
        Map<String, dynamic> valueMap = json.decode(strJson);
        objShift = Shift.fromJson(valueMap);
      }
    } catch (e) {
      objShift = null;
      print('error caught: $e');
    }
    return objShift;
  }

  List<Shift> parseShifts(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<Shift>((json) => Shift.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<Shift> GetShiftByShiftID(AuthLogin objAuthLogin,
      String strShiftID, MTAResult objMTAResult) async {
    Shift objShift = new Shift();

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strShiftID, ApiConstants.endpoint_Shift);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objShift = Shift.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objShift = new Shift(); // not sure in dart
      print('error caught: $e');
    }
    return objShift;
  }

  Future<bool> Save(AuthLogin objAuthLogin, Shift objShift,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strShiftJson = jsonEncode(objShift);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strShiftJson, ApiConstants.endpoint_Shift);
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

  Future<bool> Update(AuthLogin objAuthLogin, Shift objShift,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strShiftJson = jsonEncode(objShift);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strShiftJson, ApiConstants.endpoint_Shift);
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

  Future<bool> Delete(AuthLogin objAuthLogin, String strShiftID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Shift objShift = new Shift();
      objShift.ShiftID = strShiftID;

      String strShiftJson = jsonEncode(objShift);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strShiftJson, ApiConstants.endpoint_Shift);
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
