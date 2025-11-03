import '../models/Major.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class MajorService {
  Future<Map<String, dynamic>> fetchMajors({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/majors?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Major> majors =
      data.map((item) => Major.fromJson(item)).toList();

      return {
        'majors': majors,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load majors');
    }
  }

  Future<Major> createMajor(
      {required String name,
        required int departmentId}) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/majors'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'department_id': departmentId,
      }),
    );

    if (response.statusCode == 201) {
      return Major.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String firstError = errors.values.first[0];
      throw Exception(firstError);
    } else {
      throw Exception('Lỗi máy chủ (Code: ${response.statusCode}). Vui lòng thử lại.');
    }
  }

  Future<void> updateMajor(
      {required int id,
        required String name,
        required int departmentId}) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/majors/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
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

  Future<void> deleteMajor(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/majors/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete major');
    }
  }
}