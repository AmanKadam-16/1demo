import 'dart:convert';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'holiday.dart';

class HolidayDetails {

  /// note : Holiday Date works as primary key

//ToDo:  code optimization pending
// gets current year's all holidays
  Future<List<Holiday>> GetAllHolidayes(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async
  {
    List<Holiday> lstHoliday = [];
    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_Holiday);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstHoliday = parseHolidays(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstHoliday = [];
      print('error caught: $e');
    }
    return lstHoliday;
  }
  List<Holiday> parseHolidays(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<Holiday>((json) => Holiday.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<Holiday> GetHolidayByHolidayID(AuthLogin objAuthLogin,
      String strHolidayID, MTAResult objMTAResult) async
  {
    Holiday objHoliday = new Holiday();
    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strHolidayID, ApiConstants.endpoint_Holiday);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objHoliday = Holiday.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objHoliday = new Holiday();
      print('error caught: $e');
    }
    return objHoliday;
  }

  Future<Holiday> GetHolidayByDate(AuthLogin objAuthLogin,
      String strHolidayDate, MTAResult objMTAResult) async
  {
    Holiday objHoliday = new Holiday();
    try {
      String strData="GetByDate/"+strHolidayDate;
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strData, ApiConstants.endpoint_Holiday);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objHoliday = Holiday.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objHoliday = new Holiday();
      print('error caught: $e');
    }
    return objHoliday;
  }
  Future<List<Holiday>>  GetHolidayByHolidayYear(AuthLogin objAuthLogin,
      String strHolidayYear, MTAResult objMTAResult) async
  {
    List<Holiday> lstHoliday = [];
    try {
      String strData="GetByYear/"+strHolidayYear;
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strData, ApiConstants.endpoint_Holiday);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstHoliday = parseHolidays(objResult.ResultRecordJson);
          print('lstHoliday by year: $lstHoliday');
        }
      }
    }
    on Exception catch (e) {
      lstHoliday = [];
      print('error caught: $e');
    }
    return lstHoliday;
  }
  Future<List<Holiday>>  GetHolidayByBranchIDNYear(AuthLogin objAuthLogin,
      String strBranchID,String strYear, MTAResult objMTAResult) async
  {
    List<Holiday> lstHoliday = [];
    try {
      String strData="GetByBranchIDNYear/"+strBranchID +"/"+strYear;
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strData, ApiConstants.endpoint_Holiday);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstHoliday = parseHolidays(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstHoliday = [];
      print('error caught: $e');
    }
    return lstHoliday;
  }
  Future<List<Holiday>>  GetHolidayByBranchID(AuthLogin objAuthLogin,
      String strBranchID, MTAResult objMTAResult) async
  {
    List<Holiday> lstHoliday = [];
    try {
      String strData="GetByBranchID/"+strBranchID ;
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strData, ApiConstants.endpoint_Holiday);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstHoliday = parseHolidays(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstHoliday = [];
      print('error caught: $e');
    }
    return lstHoliday;
  }
  Future<bool> Save(AuthLogin objAuthLogin, Holiday objHoliday,
      MTAResult objMTAResult) async
  {
    bool bResult = false;
    try {
      String strHolidayJson = jsonEncode(objHoliday);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strHolidayJson, ApiConstants.endpoint_Holiday);
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

  Future<bool> Update(AuthLogin objAuthLogin, Holiday objHoliday,
      MTAResult objMTAResult) async
  {
    bool bResult = false;
    try {
      String strHolidayJson = jsonEncode(objHoliday);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strHolidayJson, ApiConstants.endpoint_Holiday);
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

  Future<bool> Delete(AuthLogin objAuthLogin, String strHolidayID,
      MTAResult objMTAResult) async
  {
    bool bResult = false;
    try {
      Holiday objHoliday = new Holiday();
      objHoliday.HolidayID = strHolidayID;

      String strHolidayJson = jsonEncode(objHoliday);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strHolidayJson, ApiConstants.endpoint_Holiday);
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
