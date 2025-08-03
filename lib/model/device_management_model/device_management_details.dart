// Details / API Interactions File

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/device_management_model/device_management_model.dart';

class DeviceManagementDetails {
  final String baseUrl = 'http://localhost:58122';

  Future<DeviceSearchResponse> searchDevices(
    AuthLogin authLogin,
    DeviceSearchRequest request,
    MTAResult result,
  ) async {
    try {      final url = Uri.parse('http://localhost:58122/api/device-proxy/search');
      
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
        result.ResultMessage = 'Devices retrieved successfully';
        return DeviceSearchResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to retrieve devices: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error searching devices: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<List<DeviceDetails>> getAllDeviceDetails(MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/GetAllDeviceDetails');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        result.IsResultPass = true;
        result.ResultMessage = 'Device details retrieved successfully';
        return data.map((json) => DeviceDetails.fromJson(json)).toList();
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to retrieve device details: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error getting device details: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<UserCountResponse> getUserCount(String devIndex, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/user-count?devIndex=$devIndex');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        result.IsResultPass = true;
        result.ResultMessage = 'User count retrieved successfully';
        return UserCountResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to retrieve user count: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) { 
      result.IsResultPass = false;
      result.ErrorMessage = 'Error getting user count: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<AddDeviceResponse> addDevice(AddDeviceRequest request, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/addDevice');
      
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
        result.ResultMessage = 'Device added successfully';
        return AddDeviceResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to add device: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error adding device: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<String> createDevice(CreateUpdateDeviceRequest request, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/CreateDevice');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        result.IsResultPass = true;
        result.ResultMessage = 'Device created successfully';
        return response.body;
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to create device: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error creating device: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<ModifyDeviceResponse> modifyDevice(ModifyDeviceRequest request, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/modifyDevice');
      
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
        result.ResultMessage = 'Device modified successfully';
        return ModifyDeviceResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to modify device: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error modifying device: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<String> updateDevice(CreateUpdateDeviceRequest request, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/UpdateDevice');
      
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        result.IsResultPass = true;
        result.ResultMessage = 'Device updated successfully';
        return response.body;
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to update device: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error updating device: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<DeleteDeviceResponse> deleteDeviceProxy(DeleteDeviceRequest request, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/delete');
      
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
        result.ResultMessage = 'Devices deleted successfully';
        return DeleteDeviceResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to delete devices: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error deleting devices: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<String> deleteDevice(String devIndex, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/DeleteDevice/$devIndex');
      
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        result.IsResultPass = true;
        result.ResultMessage = 'Device deleted successfully';
        return response.body;
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to delete device: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error deleting device: $e';
      throw Exception(result.ErrorMessage);
    }
  }

}
