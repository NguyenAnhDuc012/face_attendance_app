import '../models/Intake.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class IntakeService {
  Future<List<Intake>> fetchIntakes() async {
    try {
      final response = await http.get(Uri.parse('$API_BASE_URL/intakes'));

      if (response.statusCode == 200) {
        // API của bạn trả về một đối tượng phân trang (Paginate)
        // Chúng ta cần lấy mảng 'data' bên trong nó
        Map<String, dynamic> body = json.decode(response.body);
        List<dynamic> data = body['data']; // <-- Lấy mảng 'data'

        // Chuyển đổi mỗi item JSON trong mảng 'data' thành một object Intake
        List<Intake> intakes = data
            .map((dynamic item) => Intake.fromJson(item))
            .toList();
        return intakes;
      } else {
        throw Exception(
          'Failed to load intakes (Status ${response.statusCode})',
        );
      }
    } catch (e) {
      // Xử lý lỗi (ví dụ: không kết nối được server)
      throw Exception('Failed to connect to API: $e');
    }
  }

  // Hàm XÓA một Intake
  Future<void> deleteIntake(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/intakes/$id'),
      headers: {'Accept': 'application/json'},
    );

    // API của bạn trả về 204 No Content khi xóa thành công
    if (response.statusCode != 204) {
      throw Exception(
        'Failed to delete intake (Status ${response.statusCode})',
      );
    }
  }

  // thêm
  Future<Intake> createIntake({
    required String name,
    required int startYear,
    required int expectedGraduationYear,
  }) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/intakes'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'start_year': startYear,
        'expected_graduation_year': expectedGraduationYear,
      }),
    );

    if (response.statusCode == 201) {
      return Intake.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create intake: ${response.body}');
    }
  }

  // Sửa
  Future<void> updateIntake({
    required int id,
    required String name,
    required int startYear,
    required int expectedGraduationYear,
  }) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/intakes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'start_year': startYear,
        'expected_graduation_year': expectedGraduationYear,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update intake: ${response.statusCode}');
    }
  }
}
