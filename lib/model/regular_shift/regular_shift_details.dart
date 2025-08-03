
import 'dart:convert';
import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'regular_shift_model.dart';

class RegularShiftDetails {
  /// Delete an employee's regular shift by employee ID and shift date.
  /// Returns true if the operation is successful, false otherwise.
  Future<bool> deleteEmpRegularShift({
    required AuthLogin authLogin,
    required String employeeID,
    required String shiftDate,
    required MTAResult mtaResult,
  }) async {
    bool isSuccess = false;
    try {
      // Compose the query string as per API requirements
      String param = '?strEmployeeID=$employeeID&strShiftDate=$shiftDate';
      String endpoint = ApiConstants.endpoint_EmpRegularShift + param;
      Result result = await APIInteraction().Delete(
        authLogin,
        '', // No body required for this delete
        endpoint,
      );
      mtaResult.IsResultPass = result.IsResultPass;
      mtaResult.ResultMessage = result.ResultMessage;
      isSuccess = result.IsResultPass;
    } catch (e) {
      isSuccess = false;
      print('error caught: $e');
    }
    return isSuccess;
  }
  /// Save or update an employee's regular shift using the API.
  /// Returns true if the operation is successful, false otherwise.
  Future<bool> saveOrUpdateEmpRegularShift({
    required AuthLogin authLogin,
    required RegularShiftModel shiftModel,
    required MTAResult mtaResult,
  }) async {
    bool isSuccess = false;
    try {
      String jsonBody = jsonEncode(shiftModel.toJson());
      String endpoint = '${ApiConstants.endpoint_EmpRegularShift}/SaveOrUpdateEmpRegularShift';
      Result result = await APIInteraction().Save(
        authLogin,
        jsonBody,
        endpoint,
      );
      mtaResult.IsResultPass = result.IsResultPass;
      mtaResult.ResultMessage = result.ResultMessage;
      isSuccess = result.IsResultPass;
    } catch (e) {
      isSuccess = false;
      print('error caught: $e');
    }
    return isSuccess;
  }
  Future<List<RegularShiftModel>> getEmployeeRegularShifts({
    required AuthLogin authLogin,
    required String employeeID,
    required String startDate,
    required String endDate,
    required MTAResult mtaResult,
  }) async {
    List<RegularShiftModel> shiftList = [];
    try {
      // Prepare search JSON
      String searchJson = jsonEncode({
        "EmployeeID": employeeID,
        "StartDate": startDate,
        "EndDate": endDate,
      });
      String param = 'GetEmployeeRegularShiftByEmployeeIDStartNEndDate?strSearchJson=$searchJson';
      Result result = await APIInteraction().GetObjectByObjectID(
        authLogin,
        param,
        ApiConstants.endpoint_EmpRegularShift,
      );
      mtaResult.IsResultPass = result.IsResultPass;
      mtaResult.ResultMessage = result.ResultMessage;
      if (result.IsResultPass && result.IsMultipleRecordsInJson) {
        String jsonStr = result.ResultRecordJson;
        List<dynamic> decoded = jsonDecode(jsonStr);
        shiftList = decoded.map((e) => RegularShiftModel.fromJson(e)).toList();
      }
    } catch (e) {
      shiftList = [];
      print('error caught: $e');
    }
    return shiftList;
  }
}
