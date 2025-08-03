// Details file for device related employee operations

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/device_management_model/device_employee_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_model_HikeVision.dart';
import 'package:time_attendance/model/device_management_model/device_emloyee_edit_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_sync_model.dart';

class DeviceEmployeeDetails {
  final String baseUrl = 'http://localhost:58122';

  Future<DeviceEmployeeDetailsResponse> getEmployeesByDevId(String deviceId, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/GetEmployeesByDevId/$deviceId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        result.IsResultPass = true;
        result.ResultMessage = 'Device employees retrieved successfully';
        return DeviceEmployeeDetailsResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to retrieve device employees: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error getting device employees: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<UserSearchResponse> searchDeviceUsers(
    String devIndex,
    UserInfoSearchCond searchCond,
    MTAResult result,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/user-search');
      
      final request = UserSearchRequest(
        devIndex: devIndex,
        userInfoSearchCond: searchCond,
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        result.IsResultPass = true;
        result.ResultMessage = 'Device users retrieved successfully';
        return UserSearchResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to retrieve device users: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error searching device users: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<UserDeleteResponse> deleteDeviceUsers(
    String devIndex,
    List<String> employeeNumbers,
    MTAResult result,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/user-delete');
      
      final request = UserDeleteRequest(
        devIndex: devIndex,
        userInfoDetail: UserInfoDetail(
          mode: 'byEmployeeNo',
          employeeNoList: employeeNumbers.map((e) => EmployeeNo(employeeNo: e)).toList(),
        ),
      );

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        result.IsResultPass = true;
        result.ResultMessage = 'Device users deleted successfully';
        return UserDeleteResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to delete device users: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error deleting device users: $e';
      throw Exception(result.ErrorMessage);
    }
  }


  Future<UserModifyResponse> modifyDeviceUser(
    String devIndex,
    String employeeNo,
    String name,
    String beginTime,
    String endTime,
    bool enable,
    String timeType,
    MTAResult result,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/user-modify');
      
      final request = UserModifyRequest(
        devIndex: devIndex,
        userInfo: UserModifyInfo(
          employeeNo: employeeNo,
          name: name,
          valid: UserValidInfo(
            beginTime: beginTime,
            endTime: endTime,
            enable: true,
            timeType: timeType,
          ),
        ),
      );

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        result.IsResultPass = data['statusCode'] == 1;
        result.ResultMessage = data['statusString'];
        if (!result.IsResultPass) {
          result.ErrorMessage = data['errorMsg'] ?? 'Unknown error occurred';
        }
        return UserModifyResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to modify device user: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error modifying device user: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<bool> addDeviceEmployee(DeviceEmployeeAddRequest request, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/AddEmployee');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseString = response.body;
        result.IsResultPass = true;
        result.ResultMessage = responseString;
        return true;
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to add employee: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error adding employee: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<EmployeeBiometricSyncResponse> syncEmployeeBiometricDetails(
    String devIndex,
    MTAResult result,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/EmployeeBiometricDetailSynch');
      
      final request = EmployeeBiometricSyncRequest(devIndex: devIndex);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        result.IsResultPass = true;
        result.ResultMessage = 'Employee biometric details synced successfully';
        return EmployeeBiometricSyncResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to sync employee biometric details: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error syncing employee biometric details: $e';
      throw Exception(result.ErrorMessage);
    }
  }
}
