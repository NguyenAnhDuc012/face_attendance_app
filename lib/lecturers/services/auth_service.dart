// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/lecturer.dart';

// Đảm bảo IP của bạn là đúng (ví dụ: 192.168.1.164)
const String IP_MAY_CHU = '192.168.1.164:8000';

// URL này trỏ đến route của Giảng viên
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/lecturer';

class AuthService {

  static Future<Lecturer> login(
      String email,
      String password,
      ) async {
    // URL bây giờ sẽ là: http://192.168.1.164:8000/api/lecturer/login
    final url = Uri.parse('$API_BASE_URL/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        return Lecturer.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Email hoặc mật khẩu không đúng');
      }
    } catch (e) {
      throw Exception('Không thể kết nối đến máy chủ. Vui lòng thử lại.');
    }
  }

  // Đăng xuất
  static Future<void> logout() async {
    final url = Uri.parse('$API_BASE_URL/logout');
    try {
      // Ghi chú: Nếu API logout của bạn yêu cầu token (ví dụ: Sanctum)
      // bạn cần lấy token đã lưu và gửi lên header 'Authorization'.
      // Hiện tại, ta giả định nó là một API public.
      await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );
      // Bạn không cần quan tâm kết quả trả về,
      // vì client sẽ tự xóa dữ liệu và đăng xuất.
    } catch (e) {
      // Bỏ qua lỗi kết nối khi đăng xuất
      print('Lỗi khi gọi API logout: $e');
    }
  }
}