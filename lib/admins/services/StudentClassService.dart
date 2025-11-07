import '../models/StudentClass.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://160.22.161.111/api';

class StudentClassService {
  Future<Map<String, dynamic>> fetchStudentClasses({int page = 1}) async {
    final response = await http.get(Uri.parse('$API_BASE_URL/student-classes?page=$page'));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<StudentClass> classes = (body['data'] as List)
          .map((item) => StudentClass.fromJson(item))
          .toList();
      return {
        'studentClasses': classes,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load student classes');
    }
  }

  Future<void> deleteStudentClass(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/student-classes/$id'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete student class');
    }
  }

  Future<StudentClass> createStudentClass({required String name}) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/student-classes'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 201) {
      return StudentClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create student class');
    }
  }

  Future<void> updateStudentClass({required int id, required String name}) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/student-classes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update student class');
    }
  }
}
