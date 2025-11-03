import '../models/Subject.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class SubjectService {
  Future<Map<String, dynamic>> fetchSubjects({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/subjects?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Subject> subjects =
      data.map((item) => Subject.fromJson(item)).toList();

      return {
        'subjects': subjects,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  Future<Subject> createSubject(
      {required String name,
        required int credits,
        required int departmentId}) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/subjects'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'credits': credits,
        'department_id': departmentId,
      }),
    );

    if (response.statusCode == 201) {
      return Subject.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String firstError = errors.values.first[0];
      throw Exception(firstError);
    } else {
      throw Exception('Lỗi máy chủ (Code: ${response.statusCode}). Vui lòng thử lại.');
    }
  }

  Future<void> updateSubject(
      {required int id,
        required String name,
        required int credits,
        required int departmentId}) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/subjects/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'credits': credits,
        'department_id': departmentId,
      }),
    );

    if (response.statusCode == 200) {
      return; // Cập nhật thành công
    } else if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String firstError = errors.values.first[0];
      throw Exception(firstError);
    } else {
      throw Exception('Lỗi máy chủ (Code: ${response.statusCode}). Vui lòng thử lại.');
    }
  }

  Future<void> deleteSubject(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/subjects/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete subject');
    }
  }
}