import '../models/StudyPeriod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class StudyPeriodService {
  Future<Map<String, dynamic>> fetchStudyPeriods({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/study-periods?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<StudyPeriod> studyPeriods =
      data.map((item) => StudyPeriod.fromJson(item)).toList();

      return {
        'studyPeriods': studyPeriods,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load study periods');
    }
  }

  Future<StudyPeriod> createStudyPeriod({
    required String name,
    required int semesterId,
    String? startDate,
    String? endDate,
    required bool isActive,
  }) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/study-periods'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'semester_id': semesterId,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive,
      }),
    );

    if (response.statusCode == 201) {
      return StudyPeriod.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String firstError = errors.values.first[0];
      throw Exception(firstError);
    } else {
      throw Exception('Lỗi máy chủ (Code: ${response.statusCode}). Vui lòng thử lại.');
    }
  }

  Future<void> updateStudyPeriod({
    required int id,
    required String name,
    required int semesterId,
    String? startDate,
    String? endDate,
    required bool isActive,
  }) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/study-periods/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'semester_id': semesterId,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive,
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

  Future<void> deleteStudyPeriod(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/study-periods/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete study period');
    }
  }
}