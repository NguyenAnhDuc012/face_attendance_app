import '../models/Lecturer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://160.22.161.111/api';

class LecturerService {
  Future<Map<String, dynamic>> fetchLecturers({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/lecturers?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Lecturer> lecturers =
      data.map((item) => Lecturer.fromJson(item)).toList();

      return {
        'lecturers': lecturers,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load lecturers');
    }
  }

  Future<Lecturer> createLecturer(
      {required String fullName,
        required int facultyId,
        required String email,
        String? phone,
        required String password}) async {

    final response = await http.post(
      Uri.parse('$API_BASE_URL/lecturers'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'faculty_id': facultyId,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // 1. THÀNH CÔNG: Trả về dữ liệu
      return Lecturer.fromJson(jsonDecode(response.body));

    } else if (response.statusCode == 422) {
      // 2. LỖI VALIDATION (422): Đọc lỗi cụ thể
      Map<String, dynamic> body = jsonDecode(response.body);

      // 'errors' là key mà Laravel trả về
      Map<String, dynamic> errors = body['errors'];

      // Lấy thông báo lỗi đầu tiên tìm thấy
      String firstError = errors.values.first[0];

      // Ném (throw) lỗi này ra để UI bắt được
      throw Exception(firstError);

    } else {
      // 3. LỖI KHÁC (500, 404...): Ném lỗi chung
      throw Exception('Lỗi máy chủ (Code: ${response.statusCode}). Vui lòng thử lại.');
    }
  }

  Future<void> updateLecturer(
      {required int id,
        required String fullName,
        required int facultyId,
        required String email,
        String? phone,
        String? password // Mật khẩu là tùy chọn
      }) async {

    Map<String, dynamic> body = {
      'full_name': fullName,
      'faculty_id': facultyId,
      'email': email,
      'phone': phone,
    };

    // Chỉ thêm mật khẩu vào body nếu nó không rỗng
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.put(
      Uri.parse('$API_BASE_URL/lecturers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update lecturer');
    }
  }

  Future<void> deleteLecturer(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/lecturers/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete lecturer');
    }
  }
}