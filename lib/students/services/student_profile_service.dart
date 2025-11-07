import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_profile.dart';

const String IP_MAY_CHU = '160.22.161.111';
const String API_BASE_URL = 'http://$IP_MAY_CHU/api/student';

class StudentProfileService {

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('student_token');
  }

  // Lấy thông tin profile
  static Future<StudentProfile> getProfile() async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/profile');
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
        return StudentProfile.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Không thể tải thông tin');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Tải ảnh lên (Multipart request)
  static Future<String> uploadFaceImage(File imageFile) async {
    final token = await _getToken();
    if (token == null) throw Exception('Chưa đăng nhập.');

    final url = Uri.parse('$API_BASE_URL/upload-face-image');
    try {
      // 1. Tạo request
      var request = http.MultipartRequest('POST', url);

      // 2. Thêm header
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // 3. Thêm file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Key 'image' phải khớp với API
          imageFile.path,
        ),
      );

      // 4. Gửi request
      var streamedResponse = await request.send().timeout(const Duration(seconds: 120));
      // 5. Đọc response
      var response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        return body['new_image_url'];
      } else {
        // Lỗi 500 hoặc 422 sẽ hiển thị thông báo chi tiết từ Laravel
        throw Exception(body['message'] ?? body['errors']?.toString() ?? 'Lỗi tải lên');
      }
    }
    // Bắt lỗi timeout riêng
    on TimeoutException {
      throw Exception('Hết thời gian chờ (120s). Máy chủ VPS xử lý AI quá chậm.');
    }
    on SocketException {
      throw Exception('Lỗi mạng. Kiểm tra kết nối.');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}