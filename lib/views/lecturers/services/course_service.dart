import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/course_group.dart';
import '../model/course_session.dart';

// Dùng chung IP
const String IP_MAY_CHU = '192.168.1.164:8000';
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/lecturer';

class CourseService {
  static Future<List<StudyPeriodGroup>> getCoursesByPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Chưa đăng nhập hoặc token không tồn tại.');
    }

    final url = Uri.parse('$API_BASE_URL/courses-by-period');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Gửi token
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        List<dynamic> groupData = body['data'];
        return groupData
            .map((json) => StudyPeriodGroup.fromJson(json))
            .toList();
      } else {
        throw Exception(body['message'] ?? 'Không thể tải danh sách');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // LẤY CHI TIẾT LỚP HỌC
  static Future<CourseDetail> getCourseDetails(int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Chưa đăng nhập hoặc token không tồn tại.');
    }

    final url = Uri.parse('$API_BASE_URL/course/$courseId/sessions');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        // Trả về đối tượng CourseDetail (bao gồm cả list sessions)
        return CourseDetail.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Không thể tải chi tiết lớp học');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

}