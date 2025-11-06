// lib/services/student_attendance_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

const String IP_MAY_CHU = '192.168.1.164:8000';
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/student';

class StudentAttendanceService {

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('student_token');
  }

  // API Mới: Sinh viên tự điểm danh
  static Future<void> submitAttendance({
    required int sessionId,
    required String newStatus,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/session/$sessionId/attend');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': newStatus, // Gửi trạng thái mới
        }),
      ).timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (response.statusCode != 200 || body['status'] != true) {
        throw Exception(body['message'] ?? 'Lỗi khi điểm danh');
      }
      // Thành công

    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}