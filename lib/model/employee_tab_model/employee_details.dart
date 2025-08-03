import 'dart:convert';

import 'package:time_attendance/model/employee_tab_model/employee_complete_model.dart';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
// import 'employee_model.dart';

class EmployeeDetails {
  Future<List<Employee>> GetAllEmployees(
      AuthLogin objAuthLogin, MTAResult objMTAResult) async {
    List<Employee> lstEmployee = [];

    try {
      Result objResult = await APIInteraction()
          .GetAllObjects(objAuthLogin, ApiConstants.endpoint_Employee);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstEmployee = parseEmployees(objResult.ResultRecordJson);
        }
      }
    } on Exception catch (e) {
      lstEmployee = [];
      print('error caught: $e');
    }
    return lstEmployee;
  }

  List<Employee> parseEmployees(String responseBody) {
    try {
      final parsed =
          (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
      return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Employee> GetEmployeeByEmployeeID(AuthLogin objAuthLogin,
      String strEmployeeID, MTAResult objMTAResult) async {
    Employee objEmployee = new Employee(
        employeeProfessional: EmployeeProfessional(
            enrollID: '',
            employeeID: '',
            employeeName: '',
            companyID: '',
            departmentID: '',
            designationID: '',
            locationID: '',
            employeeTypeID: '',
            employeeType: '',
            empStatus: 0,
            dateOfEmployment: '',
            seniorEmployeeID: '',
            emailID: ''),
        employeePersonal: EmployeePersonal(
            employeeID: '',
            employeeName: '',
            localAddress: '',
            permanentAddress: '',
            gender: '',
            dateOfBirth: '',
            contactNo: '',
            mobileNumber: '',
            nationality: '',
            emailID: '',
            bloodGroup: ''));

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strEmployeeID, ApiConstants.endpoint_Employee);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          Map<String, dynamic> valueMap =
              json.decode(objResult.ResultRecordJson);
          objEmployee = Employee.fromJson(valueMap);
        }
      }
    } on Exception catch (e) {
      objEmployee = new Employee(
          employeeProfessional: EmployeeProfessional(
              enrollID: '',
              employeeID: '',
              employeeName: '',
              companyID: '',
              departmentID: '',
              designationID: '',
              locationID: '',
              employeeTypeID: '',
              employeeType: '',
              empStatus: 0,
              dateOfEmployment: '',
              seniorEmployeeID: '',
              emailID: ''),
          employeePersonal: EmployeePersonal(
              employeeID: '',
              employeeName: '',
              localAddress: '',
              permanentAddress: '',
              gender: '',
              dateOfBirth: '',
              contactNo: '',
              mobileNumber: '',
              nationality: '',
              emailID: '',
              bloodGroup: ''));
      print('error caught: $e');
    }
    return objEmployee;
  }

  Future<bool> Save(AuthLogin objAuthLogin, Employee objEmployee,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strEmployeeJson = jsonEncode(objEmployee);
      String endpoint = '${ApiConstants.endpoint_Employee}/AddEmployee';
      Result objResult = await APIInteraction()
          .Save(objAuthLogin, strEmployeeJson, endpoint);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Update(AuthLogin objAuthLogin, List<Employee> objEmployee,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strEmployeeJson = jsonEncode(objEmployee);
      String endpoint =
          '${ApiConstants.endpoint_Employee}/BulkUpdateByListOfEmployeeWithSettingProfileID';
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strEmployeeJson, endpoint);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Delete(AuthLogin objAuthLogin,
      EmployeeProfessional employeeProfessional, MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Map<String, dynamic> professionalMap = employeeProfessional.toJson();
      String strEmployeeJson =
          jsonEncode({"EmployeeProfessional": professionalMap});
      bool bMakeInActive = employeeProfessional.empStatus == 0;
      String endpoint =
          '${ApiConstants.endpoint_Employee}?strEmployeeID=${employeeProfessional.employeeID}&bMakeInActive=$bMakeInActive';

      Result objResult = await APIInteraction()
          .Delete(objAuthLogin, strEmployeeJson, endpoint);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  // Get Employee by Employee ID
  Future<Employee> GetEmployeeDetailsByID(AuthLogin objAuthLogin,
      String strEmployeeID, MTAResult objMTAResult) async {
    Employee objEmployee = Employee();
  // need to append this before passing str emp id ie.  ?strEmployeeID=<strEmployeeID>
    strEmployeeID = '?strEmployeeID=$strEmployeeID';
    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strEmployeeID, ApiConstants.endpoint_Employee);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          Map<String, dynamic> valueMap =
              json.decode(objResult.ResultRecordJson);
          objEmployee = Employee.fromJson(valueMap);
        }
      }
    } on Exception catch (e) {
      objEmployee = Employee(); // not sure in dart
      print('error caught: $e');
    }
    return objEmployee;
  }
}
