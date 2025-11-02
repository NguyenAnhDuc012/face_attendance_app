// services/AcademicYearService.dart
import '../models/AcademicYear.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class AcademicYearService {
  Future<Map<String, dynamic>> fetchAcademicYears({int page = 1}) async {
    try {
      final response =
      await http.get(Uri.parse('$API_BASE_URL/academic-years?page=$page'));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        List<dynamic> data = body['data'];
        List<AcademicYear> academicYears =
        data.map((item) => AcademicYear.fromJson(item)).toList();

        return {
          'academicYears': academicYears,
          'current_page': body['current_page'],
          'last_page': body['last_page'],
        };
      } else {
        throw Exception(
            'Failed to load academic years (Status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

  Future<void> deleteAcademicYear(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/academic-years/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception(
          'Failed to delete academic year (Status ${response.statusCode})');
    }
  }

  Future<AcademicYear> createAcademicYear({
    required int startYear,
    required int endYear,
  }) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/academic-years'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'start_year': startYear,
        'end_year': endYear,
      }),
    );

    if (response.statusCode == 201) {
      return AcademicYear.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create academic year: ${response.body}');
    }
  }

  Future<void> updateAcademicYear({
    required int id,
    required int startYear,
    required int endYear,
  }) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/academic-years/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'start_year': startYear,
        'end_year': endYear,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update academic year: ${response.statusCode}');
    }
  }
}
