import 'dart:convert';
import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'temp_weeklyOff_model.dart';

class TempWeeklyOffDetails {
  Future<TempWeeklyOffResponse> getEmployeeWeeklyOffByEmployeeViewStartNEndDate({
    required AuthLogin objAuthLogin,
    required TempWeeklyOffRequest request,
    required MTAResult objMTAResult,
  }) async {
    TempWeeklyOffResponse response = TempWeeklyOffResponse();
    List<TempWeeklyOffModel> weeklyOffList = [];
    try {
      String strSearchJson = jsonEncode(request.toJson());
      strSearchJson = '?strSearchJson=$strSearchJson';
      Result objResult = await APIInteraction().GetObjectByObjectID(
        objAuthLogin,
        strSearchJson,
        "${ApiConstants.endpoint_EmpRotationalWeeklyOff}/GetListOfEmpRotationalWeeklyOffByEmployeeViewStartNEndDateWithRange",
      );
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          weeklyOffList = parseWeeklyOffList(objResult.ResultRecordJson);
          response.isMultipleRecordsInJson = objResult.IsMultipleRecordsInJson;
          response.isResultPass = objResult.IsResultPass;
          response.loginMode = 0; // Default value since it's not in Result class
          response.resultMessage = objResult.ResultMessage;
          response.resultRecordCount = weeklyOffList.length;
          response.weeklyOffList = weeklyOffList;
          response.totalRecordCount = objResult.TotalRecordCount;
        }
      }
    } catch (e) {
      weeklyOffList = [];
    }
    return response;
  }

  List<TempWeeklyOffModel> parseWeeklyOffList(String responseBody) {
    try {
      final parsed =
          (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
      return parsed
          .map<TempWeeklyOffModel>(
              (json) => TempWeeklyOffModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveWeeklyOff(AuthLogin objAuthLogin, List<TempWeeklyOffModel> weeklyOffList, MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strWeeklyOffJson = jsonEncode(weeklyOffList);
      Result objResult = await APIInteraction().Save(
        objAuthLogin,
        strWeeklyOffJson,
        "${ApiConstants.endpoint_EmpRotationalWeeklyOff}/SaveUpdateBulkEmployeeTemporaryWeeklyOff"
      );
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass && objResult.IsMultipleRecordsInJson) {
        bResult = true;
      }
    } catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> deleteWeeklyOff(AuthLogin objAuthLogin, List<TempWeeklyOffModel> weeklyOffList, MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strWeeklyOffJson = jsonEncode(weeklyOffList);
      Result objResult = await APIInteraction().Delete(
        objAuthLogin,
        strWeeklyOffJson,
        "${ApiConstants.endpoint_EmpRotationalWeeklyOff}/DeleteBulkEmployeeTemporaryWeeklyOff"
      );
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        bResult = true;
      }
    } catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }
}