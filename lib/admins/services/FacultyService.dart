import '../models/Faculty.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class FacultyService {
  Future<Map<String, dynamic>> fetchFaculties({int page = 1}) async {
    final response = await http.get(Uri.parse('$API_BASE_URL/faculties?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Faculty> faculties = data.map((item) => Faculty.fromJson(item)).toList();

      return {
        'faculties': faculties,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load faculties');
    }
  }

  Future<Faculty> createFaculty({required String name, required int facilityId}) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/faculties'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'name': name, 'facility_id': facilityId}),
    );

    if (response.statusCode == 201) {
      return Faculty.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create faculty');
    }
  }

  Future<void> updateFaculty({required int id, required String name, required int facilityId}) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/faculties/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'facility_id': facilityId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update faculty');
    }
  }

  Future<void> deleteFaculty(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/faculties/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete faculty');
    }
  }
}
