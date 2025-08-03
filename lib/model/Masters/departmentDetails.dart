import 'dart:convert';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'department.dart';

class DepartmentDetails {
//ToDo:  code optimization pending
  Future<List<Department>> GetAllDepartmentes(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<Department> lstDepartment = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_Department);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstDepartment = parseDepartments(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstDepartment = [];
      print('error caught: $e');
    }
    return lstDepartment;
  }

  List<Department> parseDepartments(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<Department>((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<Department> GetDepartmentByDepartmentID(AuthLogin objAuthLogin,
      String strDepartmentID, MTAResult objMTAResult) async {
    Department objDepartment = new Department();

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strDepartmentID, ApiConstants.endpoint_Department);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objDepartment = Department.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objDepartment = new Department(); // not sure in dart
      print('error caught: $e');
    }
    return objDepartment;
  }

  Future<bool> Save(AuthLogin objAuthLogin, Department objDepartment,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strDepartmentJson = jsonEncode(objDepartment);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strDepartmentJson, ApiConstants.endpoint_Department);
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

  Future<bool> Update(AuthLogin objAuthLogin, Department objDepartment,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strDepartmentJson = jsonEncode(objDepartment);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strDepartmentJson, ApiConstants.endpoint_Department);
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

  Future<bool> Delete(AuthLogin objAuthLogin, String strDepartmentID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Department objDepartment = new Department();
      objDepartment.DepartmentID = strDepartmentID;

      String strDepartmentJson = jsonEncode(objDepartment);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strDepartmentJson, ApiConstants.endpoint_Department);
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
