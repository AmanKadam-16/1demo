import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/location_model/location_model.dart';

class LocationDetails {
  final String baseUrl = 'http://localhost:58122';

  Future<List<Location>> getAllLocations(MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/api/locations/all');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        result.IsResultPass = true;
        result.ResultMessage = 'Locations retrieved successfully';
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to retrieve locations: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error getting locations: $e';
      throw Exception(result.ErrorMessage);
    }
  }

  Future<String> createLocation(CreateLocationRequest request, MTAResult result) async {
    try {
      final url = Uri.parse('$baseUrl/api/locations/create');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        result.IsResultPass = true;
        result.ResultMessage = 'Location created successfully';
        return response.body;
      } else {
        result.IsResultPass = false;
        result.ErrorMessage = 'Failed to create location: ${response.statusCode}';
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error creating location: $e';
      throw Exception(result.ErrorMessage);
    }
  }
}
