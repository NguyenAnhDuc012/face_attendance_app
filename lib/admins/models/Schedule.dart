import 'Course.dart';
import 'Room.dart';

class Schedule {
  final int id;
  final int courseId;
  final int roomId;
  final int dayOfWeek; // 1 = Thứ 2, 7 = Chủ Nhật
  final String startTime; // "HH:mm"
  final String endTime;   // "HH:mm"

  // Dữ liệu lồng
  final Course? course;
  final Room? room;

  Schedule({
    required this.id,
    required this.courseId,
    required this.roomId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.course,
    this.room,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    // API trả về "HH:mm:ss", chúng ta chỉ cần "HH:mm"
    String formatTime(String time) {
      try {
        return time.substring(0, 5);
      } catch (e) {
        return time;
      }
    }

    return Schedule(
      id: int.parse(json['id'].toString()),
      courseId: int.parse(json['course_id'].toString()),
      roomId: int.parse(json['room_id'].toString()),
      dayOfWeek: int.parse(json['day_of_week'].toString()),
      startTime: formatTime(json['start_time']),
      endTime: formatTime(json['end_time']),

      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
    );
  }
}