import 'dart:convert';

import 'package:time_attendance/model/Masters/shiftPattern.dart';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';

class ShiftPatternDetails {
//ToDo:  code optimization pending
  Future<List<ShiftPatternModel>> GetAllShiftPatterns(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<ShiftPatternModel> lstShiftPattern = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_ShiftPattern);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstShiftPattern = parseShiftPatterns(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstShiftPattern = [];
      print('error caught: $e');
    }
    return lstShiftPattern;
  }

  List<ShiftPatternModel> parseShiftPatterns(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<ShiftPatternModel>((json) => ShiftPatternModel.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

    Future<bool> Delete(AuthLogin objAuthLogin, String strShiftPatternID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Map<String, dynamic> objShiftPattern = {
        'PatternID': int.parse(strShiftPatternID)
      };

      String strShiftPatternJson = jsonEncode(objShiftPattern);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strShiftPatternJson, ApiConstants.endpoint_ShiftPattern);
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

  Future<bool> Save(AuthLogin objAuthLogin, String patternName, List<String> shiftsInPattern,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Map<String, dynamic> requestData = {
        'PatternName': patternName,
        'ShiftsInPattern': shiftsInPattern,
      };

      String strShiftPatternJson = jsonEncode(requestData);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strShiftPatternJson, ApiConstants.endpoint_ShiftPattern);
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

  Future<bool> Update(AuthLogin objAuthLogin, int patternId, String patternName, List<String> shiftsInPattern,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Map<String, dynamic> requestData = {
        'PatternID': patternId,
        'PatternName': patternName,
        'ShiftsInPattern': shiftsInPattern,
      };

      String strShiftPatternJson = jsonEncode(requestData);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strShiftPatternJson, ApiConstants.endpoint_ShiftPattern);
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
