import '../models/Schedule.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class ScheduleService {
  Future<Map<String, dynamic>> fetchSchedules({int page = 1}) async {
    final response =
    await http.get(Uri.parse('$API_BASE_URL/schedules?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> data = body['data'];
      List<Schedule> schedules =
      data.map((item) => Schedule.fromJson(item)).toList();

      return {
        'schedules': schedules,
        'current_page': body['current_page'],
        'last_page': body['last_page'],
      };
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<Schedule> createSchedule(
      {required int courseId,
        required int roomId,
        required int dayOfWeek,
        required String startTime, // "HH:mm"
        required String endTime    // "HH:mm"
      }) async {

    final response = await http.post(
      Uri.parse('$API_BASE_URL/schedules'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'course_id': courseId,
        'room_id': roomId,
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );

    if (response.statusCode == 201) {
      return Schedule.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String firstError = errors.values.first[0];
      throw Exception(firstError);
    } else {
      throw Exception('Lỗi máy chủ (Code: ${response.statusCode}).');
    }
  }

  Future<void> updateSchedule(
      {required int id,
        required int courseId,
        required int roomId,
        required int dayOfWeek,
        required String startTime, // "HH:mm"
        required String endTime    // "HH:mm"
      }) async {

    final response = await http.put(
      Uri.parse('$API_BASE_URL/schedules/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'course_id': courseId,
        'room_id': roomId,
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 422) {
        Map<String, dynamic> body = jsonDecode(response.body);
        Map<String, dynamic> errors = body['errors'];
        String firstError = errors.values.first[0];
        throw Exception(firstError);
      } else {
        throw Exception('Lỗi máy chủ (Code: ${response.statusCode}).');
      }
    }
  }

  Future<void> deleteSchedule(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/schedules/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete schedule');
    }
  }
}