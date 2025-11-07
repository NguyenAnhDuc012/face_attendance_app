import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Admin.dart';

const String API_BASE_URL = 'http://160.22.161.111/api';

class AuthService {
  // Đăng ký tài khoản
  Future<Admin> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Admin.fromJson(data['data']);
      } else {
        throw Exception(
          'Đăng ký thất bại (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối đến API: $e');
    }
  }

  // đăng nhập
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$API_BASE_URL/login');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 422) {
      final body = jsonDecode(response.body);
      return {
        'status': false,
        'message': body['message'] ?? 'Email hoặc mật khẩu không đúng',
      };
    } else {
      throw Exception('Lỗi máy chủ (${response.statusCode}): ${response.body}');
    }
  }
}
