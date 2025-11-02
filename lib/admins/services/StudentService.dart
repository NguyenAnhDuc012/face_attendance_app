import '../models/Student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class StudentService {
  Future<Map<String, dynamic>> fetchStudents({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/students?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Student> students =
      data.map((item) => Student.fromJson(item)).toList();

      return {
        'students': students,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<Student> createStudent({
    required String fullName,
    required String dob,
    required int classId,
    required String email,
    String? phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/students'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'dob': dob,
        'class_id': classId,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create student');
    }
  }

  Future<void> updateStudent({
    required int id,
    required String fullName,
    required String dob,
    required int classId,
    required String email,
    String? phone,
    String? password, // Mật khẩu có thể là null khi cập nhật
  }) async {
    Map<String, dynamic> body = {
      'full_name': fullName,
      'dob': dob,
      'class_id': classId,
      'email': email,
      'phone': phone,
    };

    // Chỉ thêm mật khẩu vào body nếu nó không rỗng
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.put(
      Uri.parse('$API_BASE_URL/students/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/students/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete student');
    }
  }
}