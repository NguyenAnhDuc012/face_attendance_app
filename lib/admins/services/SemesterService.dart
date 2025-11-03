import '../models/Semester.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class SemesterService {
  Future<Map<String, dynamic>> fetchSemesters({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/semesters?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Semester> semesters =
      data.map((item) => Semester.fromJson(item)).toList();

      return {
        'semesters': semesters,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load semesters');
    }
  }

  Future<Semester> createSemester(
      {required String name,
        required int academicYearId,
        String? startDate,
        String? endDate,
        required bool isActive,
      }) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/semesters'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'academic_year_id': academicYearId,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive,
      }),
    );

    if (response.statusCode == 201) {
      return Semester.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) { // Xử lý lỗi validation
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String firstError = errors.values.first[0];
      throw Exception(firstError);
    } else {
      throw Exception('Lỗi khi tạo học kỳ: ${response.body}');
    }
  }

  Future<void> updateSemester(
      {required int id,
        required String name,
        required int academicYearId,
        String? startDate,
        String? endDate,
        required bool isActive,
      }) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/semesters/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'academic_year_id': academicYearId,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive,
      }),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 422) { // Xử lý lỗi validation
        Map<String, dynamic> body = jsonDecode(response.body);
        Map<String, dynamic> errors = body['errors'];
        String firstError = errors.values.first[0];
        throw Exception(firstError);
      } else {
        throw Exception('Lỗi khi cập nhật học kỳ: ${response.statusCode}');
      }
    }
  }

  Future<void> deleteSemester(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/semesters/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete semester');
    }
  }
}