import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/device_management_model/device_employee_transfer_model.dart';

class DeviceEmployeeTransferDetails {
  final String baseUrl = 'http://localhost:58122';

  Future<MegaTransferResponse> transferEmployees(
    MegaTransferRequest request,
    MTAResult result,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/device-proxy/MegaEmployeeTransferProcess');
      
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
        result.ResultMessage = 'Employee transfer process completed successfully';
        return MegaTransferResponse.fromJson(data);
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to transfer employees: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error transferring employees: $e';
      throw Exception(result.ErrorMessage);
    }
  }
}