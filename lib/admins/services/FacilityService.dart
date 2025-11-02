import '../models/Facility.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class FacilityService {
  Future<Map<String, dynamic>> fetchFacilities({int page = 1}) async {
    final response = await http.get(Uri.parse('$API_BASE_URL/facilities?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Facility> facilities = data.map((item) => Facility.fromJson(item)).toList();

      return {
        'facilities': facilities,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load facilities');
    }
  }

  Future<Facility> createFacility({required String name}) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/facilities'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return Facility.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create facility');
    }
  }

  Future<void> updateFacility({required int id, required String name}) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/facilities/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update facility');
    }
  }

  Future<void> deleteFacility(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/facilities/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete facility');
    }
  }
}
