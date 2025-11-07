import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student.dart';

// IP máy chủ của bạn
const String IP_MAY_CHU = '160.22.161.111';
// API trỏ đến route của student
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/student';

class StudentAuthService {
  static Future<Student> login(String email, String password) async {
    final url = Uri.parse('$API_BASE_URL/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final studentData = body['data']['student'];
        final token = body['data']['token'];

        // Lưu token và thông tin (dùng key riêng cho student)
        await prefs.setString('student_token', token);
        await prefs.setInt('student_id', studentData['id']);
        await prefs.setString('student_email', studentData['email']);
        await prefs.setString('student_full_name', studentData['full_name']);

        return Student.fromJson(studentData);
      } else {
        throw Exception(body['message'] ?? 'Email hoặc mật khẩu không đúng');
      }
    } on TimeoutException {
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    } on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra IP ($IP_MAY_CHU) hoặc kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  static Future<void> logout() async {
    final url = Uri.parse('$API_BASE_URL/logout');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) return;

    try {
      await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 5)); // Thêm timeout cho logout
    } catch (e) {
      print('Lỗi khi gọi API logout (có thể bỏ qua): $e');
    }
  }

}