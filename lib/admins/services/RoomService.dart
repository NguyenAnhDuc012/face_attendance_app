import '../models/Room.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class RoomService {
  // Lấy danh sách rooms với phân trang
  Future<Map<String, dynamic>> fetchRooms({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$API_BASE_URL/rooms?page=$page'));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        List<dynamic> data = body['data'];
        List<Room> rooms = data.map((item) => Room.fromJson(item)).toList();

        return {
          'rooms': rooms,
          'current_page': body['current_page'],
          'last_page': body['last_page'],
        };
      } else {
        throw Exception('Failed to load rooms (Status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

  // Xóa phòng
  Future<void> deleteRoom(int id) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/rooms/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete room (Status ${response.statusCode})');
    }
  }

  // Tạo phòng mới
  Future<Room> createRoom({required String name}) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/rooms'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return Room.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create room: ${response.body}');
    }
  }

  // Cập nhật phòng
  Future<void> updateRoom({required int id, required String name}) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/rooms/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update room: ${response.statusCode}');
    }
  }
}
