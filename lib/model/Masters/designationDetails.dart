import 'dart:convert';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'designation.dart';

class DesignationDetails {
//ToDo:  code optimization pending
  Future<List<Designation>> GetAllDesignationes(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<Designation> lstDesignation = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_Designation);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstDesignation = parseDesignations(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstDesignation = [];
      print('error caught: $e');
    }
    return lstDesignation;
  }

  List<Designation> parseDesignations(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<Designation>((json) => Designation.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<Designation> GetDesignationByDesignationID(AuthLogin objAuthLogin,
      String strDesignationID, MTAResult objMTAResult) async {
    Designation objDesignation = new Designation();

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strDesignationID, ApiConstants.endpoint_Designation);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objDesignation = Designation.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objDesignation = new Designation(); // not sure in dart
      print('error caught: $e');
    }
    return objDesignation;
  }

  Future<bool> Save(AuthLogin objAuthLogin, Designation objDesignation,
      MTAResult objMTAResult) async {
    bool bResult = false;

    try {
      String strDesignationJson = jsonEncode(objDesignation);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strDesignationJson, ApiConstants.endpoint_Designation);
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

  Future<bool> Update(AuthLogin objAuthLogin, Designation objDesignation,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strDesignationJson = jsonEncode(objDesignation);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strDesignationJson, ApiConstants.endpoint_Designation);
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

  Future<bool> Delete(AuthLogin objAuthLogin, String strDesignationID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Designation objDesignation = new Designation();
      objDesignation.DesignationID = strDesignationID;

      String strDesignationJson = jsonEncode(objDesignation);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strDesignationJson, ApiConstants.endpoint_Designation);
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
