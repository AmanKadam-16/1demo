import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/Constants.dart';
import 'package:time_attendance/Data/ServerInteration/APIIntraction.dart';
import 'package:time_attendance/Data/ServerInteration/Result.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'manualAttendance_model.dart';
import 'dart:convert';

// Details /api interaction file for Regularization
class ManualAttendanceDetails {
  Future<List<ManualAttendanceModel>> GetMonthlyAttendance(
    AuthLogin objAuthLogin,
    String employeeId,
    String month,
    String year,
    String status,
    MTAResult objMTAResult,
  ) async {
    List<ManualAttendanceModel> lstManualAttendance = [];

    try {
      String url = "${ApiConstants.endpoint_manualAttendance}/Monthly?strEmployeeID=$employeeId&strMonth=$month&strYear=$year&strStatus=$status";
      
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, url);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstManualAttendance = manualAttendanceModelFromJson(strJson);
        }
      }
    } on Exception catch (e) {
      lstManualAttendance = [];
      print('error caught: $e');
    }
    return lstManualAttendance;
  }

  Future<bool> DeleteAttendance(
    AuthLogin objAuthLogin,
    String employeeId,
    DateTime shiftDate,
    MTAResult objMTAResult,
  ) async {
    bool bResult = false;
    try {
      String formattedDate = "${shiftDate.year}-${shiftDate.month.toString().padLeft(2, '0')}-${shiftDate.day.toString().padLeft(2, '0')}";
      String url = "${ApiConstants.endpoint_manualAttendance}?strEmployeeID=$employeeId&dtShiftDate=$formattedDate";
      
      Result objResult = await APIInteraction().Delete(objAuthLogin, "", url);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<ManualAttendanceModel?> GetAttendanceRegularization(
    AuthLogin objAuthLogin,
    String employeeId,
    DateTime shiftDate,
    MTAResult objMTAResult,
  ) async {
    ManualAttendanceModel? objManualAttendance;

    try {
      String formattedDate = "${shiftDate.year}-${shiftDate.month.toString().padLeft(2, '0')}-${shiftDate.day.toString().padLeft(2, '0')}";
      String url = "${ApiConstants.endpoint_manualAttendance}?strEmployeeID=$employeeId&dtShiftDate=$formattedDate";
        Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, url);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass && !objResult.IsMultipleRecordsInJson) {
        String strJson = objResult.ResultRecordJson;
        objManualAttendance = ManualAttendanceModel.fromJson(json.decode(strJson));
      }
    } on Exception catch (e) {
      objManualAttendance = null;
      print('error caught: $e');
    }
    return objManualAttendance;
  }
}