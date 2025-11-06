import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_course_group.dart';
import '../model/student_course_session.dart';

// IP máy chủ
const String IP_MAY_CHU = '192.168.1.164:8000';
// API trỏ đến route của student
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/student';

class StudentCourseService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('student_token');
  }

  static Future<List<StudentStudyPeriodGroup>> getMyCoursesByPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    // Lấy token của SINH VIÊN
    final token = prefs.getString('student_token');

    if (token == null) {
      throw Exception('Chưa đăng nhập (student token not found).');
    }

    // Gọi API của Student
    final url = Uri.parse('$API_BASE_URL/my-courses');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        List<dynamic> groupData = body['data'];
        return groupData
            .map((json) => StudentStudyPeriodGroup.fromJson(json))
            .toList();
      } else {
        throw Exception(body['message'] ?? 'Không thể tải danh sách');
      }
    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP ($IP_MAY_CHU) hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  static Future<StudentCourseDetail> getCourseDetails(int courseId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    // API mới
    final url = Uri.parse('$API_BASE_URL/course/$courseId/sessions');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        // Dùng model mới
        return StudentCourseDetail.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Không thể tải chi tiết lớp học');
      }
    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

}