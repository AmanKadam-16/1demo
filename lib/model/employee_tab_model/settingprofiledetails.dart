// lib/model/employee_tab_model/settingprofiledetails.dart

import 'dart:convert';
import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'settingprofile.dart';

class SettingProfileDetails {
  Future<List<SettingProfileModel>> GetAllSettingProfiles(
      AuthLogin objAuthLogin, MTAResult objMTAResult) async {
    List<SettingProfileModel> lstSettingProfile = [];

    try {
      Result objResult = await APIInteraction()
          .GetAllObjects(objAuthLogin, ApiConstants.endpoint_SettingProfile);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstSettingProfile = settingProfileModelFromJson(strJson);
        }
      }
    } on Exception catch (e) {
      lstSettingProfile = [];
      print('error caught: $e');
    }
    return lstSettingProfile;
  }

  Future<bool> Save(AuthLogin objAuthLogin, SettingProfileModel objEmpSettingProfile, MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      // API expects the JSON string inside another JSON object
      String strEmpSettingProfileJson = jsonEncode(objEmpSettingProfile.toJson());
      Map<String, String> jsonPayload = {"JsonString": strEmpSettingProfileJson};
      String finalJson = jsonEncode(jsonPayload);

      Result objResult = await APIInteraction().Save(objAuthLogin, finalJson, ApiConstants.endpoint_SettingProfile);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      bResult = objResult.IsResultPass;
    } on Exception catch (e) {
      bResult = false;
      objMTAResult.ErrorMessage = e.toString();
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Update(AuthLogin objAuthLogin, SettingProfileModel objEmpSettingProfile, MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      // API expects the JSON string inside another JSON object
      String strEmpSettingProfileJson = jsonEncode(objEmpSettingProfile.toJson());
      Map<String, String> jsonPayload = {"JsonString": strEmpSettingProfileJson};
      String finalJson = jsonEncode(jsonPayload);

      Result objResult = await APIInteraction().Update(objAuthLogin, finalJson, ApiConstants.endpoint_SettingProfile);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      bResult = objResult.IsResultPass;
    } on Exception catch (e) {
      bResult = false;
      objMTAResult.ErrorMessage = e.toString();
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Delete(AuthLogin objAuthLogin, String strEmpSettingProfileID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String endpoint =
          "${ApiConstants.endpoint_SettingProfile}?strEmpSettingProfileID=$strEmpSettingProfileID";
      Result objResult =
          await APIInteraction().Delete(objAuthLogin, "", endpoint);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      bResult = objResult.IsResultPass;
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }
}