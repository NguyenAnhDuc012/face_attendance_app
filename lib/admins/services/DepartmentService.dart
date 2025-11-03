import '../models/Department.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class DepartmentService {
  Future<Map<String, dynamic>> fetchDepartments({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/departments?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Department> departments =
      data.map((item) => Department.fromJson(item)).toList();

      return {
        'departments': departments,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<Department> createDepartment(
      {required String name, required int facultyId}) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/departments'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'name': name, 'faculty_id': facultyId}),
    );

    if (response.statusCode == 201) {
      return Department.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create department');
    }
  }

  Future<void> updateDepartment(
      {required int id,
        required String name,
        required int facultyId}) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/departments/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'faculty_id': facultyId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update department');
    }
  }

  Future<void> deleteDepartment(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/departments/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete department');
    }
  }
}