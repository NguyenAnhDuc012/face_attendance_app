// lib/services/student_schedule_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_today_schedule.dart';

const String IP_MAY_CHU = '160.22.161.111';
// API trỏ đến route của student
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/student';

class StudentScheduleService {

  static Future<List<StudentTodaySchedule>> getTodaySchedule() async {
    final prefs = await SharedPreferences.getInstance();
    // LẤY TOKEN CỦA SINH VIÊN
    final token = prefs.getString('student_token');

    if (token == null) {
      throw Exception('Chưa đăng nhập (student token not found).');
    }

    final url = Uri.parse('$API_BASE_URL/today-schedule');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Gửi token
        },
      ).timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        List<dynamic> scheduleData = body['data'];
        return scheduleData
            .map((json) => StudentTodaySchedule.fromJson(json))
            .toList();
      } else {
        throw Exception(body['message'] ?? 'Không thể tải lịch học');
      }
    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP ($IP_MAY_CHU) hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}