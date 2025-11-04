import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/today_schedule.dart';

// Dùng chung IP
const String IP_MAY_CHU = '192.168.1.164:8000';
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/lecturer';

class ScheduleService {
  static Future<List<TodaySchedule>> getTodaySchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Chưa đăng nhập hoặc token không tồn tại.');
    }

    final url = Uri.parse('$API_BASE_URL/today-schedule');

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
        List<dynamic> scheduleData = body['data'];
        return scheduleData
            .map((json) => TodaySchedule.fromJson(json))
            .toList();
      } else {
        throw Exception(body['message'] ?? 'Không thể tải lịch học');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}