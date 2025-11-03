import '../models/Course.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class CourseService {
  Future<Map<String, dynamic>> fetchCourses({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/courses?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Course> courses =
      data.map((item) => Course.fromJson(item)).toList();

      return {
        'courses': courses,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<Course> createCourse(
      {required int subjectId,
        required int classId,
        required int studyPeriodId,
        required int lecturerId}) async {

    final response = await http.post(
      Uri.parse('$API_BASE_URL/courses'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'subject_id': subjectId,
        'class_id': classId,
        'study_period_id': studyPeriodId,
        'lecturer_id': lecturerId,
      }),
    );

    if (response.statusCode == 201) {
      return Course.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String firstError = errors.values.first[0];
      throw Exception(firstError);
    } else {
      throw Exception('Lỗi máy chủ (Code: ${response.statusCode}).');
    }
  }

  Future<void> updateCourse(
      {required int id,
        required int subjectId,
        required int classId,
        required int studyPeriodId,
        required int lecturerId}) async {

    final response = await http.put(
      Uri.parse('$API_BASE_URL/courses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'subject_id': subjectId,
        'class_id': classId,
        'study_period_id': studyPeriodId,
        'lecturer_id': lecturerId,
      }),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 422) {
        Map<String, dynamic> body = jsonDecode(response.body);
        Map<String, dynamic> errors = body['errors'];
        String firstError = errors.values.first[0];
        throw Exception(firstError);
      } else {
        throw Exception('Lỗi máy chủ (Code: ${response.statusCode}).');
      }
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/courses/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete course');
    }
  }
}