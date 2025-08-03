import 'dart:convert';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'empType.dart';

class EmpTypeDetails {
//ToDo:  code optimization pending
  Future<List<EmpType>> GetAllEmpTypees(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<EmpType> lstEmpType = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_EmpType);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstEmpType = parseEmpTypes(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstEmpType = [];
      print('error caught: $e');
    }
    return lstEmpType;
  }

  List<EmpType> parseEmpTypes(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<EmpType>((json) => EmpType.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<EmpType> GetEmpTypeByEmpTypeID(AuthLogin objAuthLogin,
      String strEmpTypeID, MTAResult objMTAResult) async {
    EmpType objEmpType = new EmpType();

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strEmpTypeID, ApiConstants.endpoint_EmpType);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objEmpType = EmpType.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objEmpType = new EmpType(); // not sure in dart
      print('error caught: $e');
    }
    return objEmpType;
  }

  Future<bool> Save(AuthLogin objAuthLogin, EmpType objEmpType,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strEmpTypeJson = jsonEncode(objEmpType);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strEmpTypeJson, ApiConstants.endpoint_EmpType);
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

  Future<bool> Update(AuthLogin objAuthLogin, EmpType objEmpType,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strEmpTypeJson = jsonEncode(objEmpType);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strEmpTypeJson, ApiConstants.endpoint_EmpType);
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

  Future<bool> Delete(AuthLogin objAuthLogin, String strEmpTypeID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      EmpType objEmpType = new EmpType();
      objEmpType.EmpTypeID = strEmpTypeID;

      String strEmpTypeJson = jsonEncode(objEmpType);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strEmpTypeJson, ApiConstants.endpoint_EmpType);
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
