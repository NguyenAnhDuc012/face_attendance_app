// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // 1. Import dart:io để bắt SocketException
import 'dart:async'; // 2. Import dart:async để bắt TimeoutException

import 'package:shared_preferences/shared_preferences.dart';
// Đảm bảo đường dẫn này đúng
import '../model/lecturer.dart';

const String IP_MAY_CHU = '160.22.161.111';
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/lecturer';

class AuthService {
  static Future<Lecturer> login(String email, String password) async {
    final url = Uri.parse('$API_BASE_URL/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(
        // 3. Thêm thời gian chờ (timeout) 10 giây
        const Duration(seconds: 10),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final lecturerData = body['data']['lecturer'];
        final token = body['data']['token'];

        await prefs.setString('auth_token', token);
        await prefs.setInt('user_id', lecturerData['id']);
        await prefs.setString('user_email', lecturerData['email']);
        await prefs.setString('user_full_name', lecturerData['full_name']);

        return Lecturer.fromJson(lecturerData);
      } else {
        // Lỗi 401 hoặc 422 (Email/pass sai)
        throw Exception(body['message'] ?? 'Email hoặc mật khẩu không đúng');
      }
    }

    // ===== 4. BẮT LỖI CHI TIẾT =====

    on TimeoutException catch (_) {
      // Lỗi hết thời gian chờ
      throw Exception('Hết thời gian chờ. Máy chủ phản hồi quá chậm.');
    }
    on SocketException catch (e) {
      // Lỗi liên quan đến mạng (IP, Port, Firewall)
      if (e.osError != null) {
        final osErrorMessage = e.osError!.message.toLowerCase();

        if (osErrorMessage.contains('connection refused')) {
          // Lỗi: Server không chạy
          throw Exception('Kết nối bị từ chối. Server (Laravel) có đang chạy không?');
        }
        if (osErrorMessage.contains('connection timed out') || osErrorMessage.contains('no route to host')) {
          // Lỗi: IP sai hoặc Firewall
          throw Exception('Không tìm thấy máy chủ. IP ($IP_MAY_CHU) có đúng không, hoặc Firewall có đang chặn port 8000 không?');
        }
      }
      // Lỗi socket chung
      throw Exception('Lỗi mạng: $e. Bạn có đang kết nối Wi-Fi không?');
    }
    on http.ClientException catch (e) {
      // Lỗi từ chính client http
      throw Exception('Lỗi Client: $e. Vui lòng thử lại.');
    }
    catch (e) {
      // Các lỗi khác (ví dụ: lỗi parse JSON nếu server trả về HTML)
      throw Exception('Lỗi không xác định: $e');
    }
  }

  // ... (Hàm logout của bạn)
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