import '../models/Intake.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://160.22.161.111/api';

class IntakeService {
  Future<Map<String, dynamic>> fetchIntakes({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$API_BASE_URL/intakes?page=$page'));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        List<dynamic> data = body['data'];
        List<Intake> intakes = data.map((item) => Intake.fromJson(item)).toList();

        return {
          'intakes': intakes,
          'current_page': body['current_page'],
          'last_page': body['last_page'],
        };
      } else {
        throw Exception('Failed to load intakes (Status ${response.statusCode})');
      }
    } catch (e) {
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
