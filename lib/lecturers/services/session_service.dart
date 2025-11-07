// lib/services/session_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/session_detail.dart';
import '../model/student_attendance_record.dart';

// Dùng chung IP
const String IP_MAY_CHU = '160.22.161.111';
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/lecturer';

class SessionService {

  // Lấy token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // API 1: Lấy chi tiết buổi học
  static Future<SessionDetail> getSessionDetails(int sessionId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/session/$sessionId');
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
        return SessionDetail.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Không thể tải chi tiết');
      }
    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP ($IP_MAY_CHU) hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  // API 2: Bắt đầu buổi điểm danh
  static Future<String?> startAttendance({
    required int sessionId,
    required String mode,
    required int duration,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/session/$sessionId/start');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'attendance_mode': mode,
          'duration_minutes': duration,
        }),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);

      if (response.statusCode != 200 || body['status'] != true) {
        throw Exception(body['message'] ?? 'Lỗi không xác định từ máy chủ');
      }

      // 2. Lấy dữ liệu trả về từ API
      final responseData = body['data'];

      // 3. Kiểm tra xem API có trả về qr_token không
      if (responseData != null && responseData['qr_token'] != null) {
        return responseData['qr_token'] as String; // Trả về token
      }

      return null; // Trả về null nếu là chế độ 'manual'

    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP ($IP_MAY_CHU) hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  // KẾT THÚC ĐIỂM DANH
  static Future<void> endAttendance({
    required int sessionId,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/session/$sessionId/end');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(body['message'] ?? 'Lỗi không xác định từ máy chủ');
      }

      if (body['status'] != true) {
        throw Exception(body['message'] ?? 'Máy chủ báo lỗi.');
      }
      // Thành công

    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP ($IP_MAY_CHU) hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  // LẤY DANH SÁCH ĐIỂM DANH
  static Future<List<StudentAttendanceRecord>> getAttendanceRecords(int sessionId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/session/$sessionId/records');
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
        List<dynamic> recordsData = body['data'];
        return recordsData
            .map((json) => StudentAttendanceRecord.fromJson(json))
            .toList();
      } else {
        throw Exception(body['message'] ?? 'Không thể tải danh sách');
      }
    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  static Future<void> updateRecordStatus({
    required int recordId,
    required String newStatus,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/record/$recordId/update-status');
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
        throw Exception(body['message'] ?? 'Lỗi khi cập nhật trạng thái');
      }
      // Thành công (Không cần trả về gì)

    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

}