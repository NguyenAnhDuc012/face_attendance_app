import 'package:flutter/material.dart';

// Model cho một buổi học (Session) của Sinh viên
class StudentCourseSession {
  final int sessionId;
  final DateTime sessionDate; // Dùng DateTime để so sánh
  final String startTime;
  final String endTime;
  final String roomName;
  final String sessionStatus; // 'pending', 'active', 'closed'
  final String myAttendanceStatus; // 'present', 'absent', 'late', 'chưa có'
  final String? myCheckInTime;

  StudentCourseSession({
    required this.sessionId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.roomName,
    required this.sessionStatus,
    required this.myAttendanceStatus,
    this.myCheckInTime,
  });

  factory StudentCourseSession.fromJson(Map<String, dynamic> json) {
    // Tách chuỗi "YYYY-MM-DD"
    final parts = (json['session_date'] as String).split('-');
    final DateTime sessionDate = DateTime(
      int.parse(parts[0]), // Năm
      int.parse(parts[1]), // Tháng
      int.parse(parts[2]), // Ngày
    );

    return StudentCourseSession(
      sessionId: json['session_id'],
      sessionDate: sessionDate,
      startTime: json['start_time'],
      endTime: json['end_time'],
      roomName: json['room_name'],
      sessionStatus: json['session_status'],
      myAttendanceStatus: json['my_attendance_status'],
      myCheckInTime: json['my_check_in_time'],
    );
  }

  // Helper để lấy text cho trạng thái của SINH VIÊN
  String get myStatusText {
    switch (myAttendanceStatus) {
      case 'present':
        return 'Có mặt';
      case 'late':
        return 'Có mặt (Trễ)';
      case 'absent':
        return 'Vắng mặt';
      case 'excused':
        return 'Vắng (Có phép)';
      default:
        return 'Chưa điểm danh';
    }
  }

  // Helper để lấy màu cho trạng thái của SINH VIÊN
  Color get myStatusColor {
    switch (myAttendanceStatus) {
      case 'present':
      case 'late':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'excused':
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }
}

// Model cho toàn bộ màn hình (AppBar + List)
class StudentCourseDetail {
  final String courseName;
  final String lecturerName;
  final List<StudentCourseSession> sessions;

  StudentCourseDetail({
    required this.courseName,
    required this.lecturerName,
    required this.sessions,
  });

  factory StudentCourseDetail.fromJson(Map<String, dynamic> json) {
    var sessionList = json['sessions'] as List;
    List<StudentCourseSession> sessions =
    sessionList.map((i) => StudentCourseSession.fromJson(i)).toList();

    return StudentCourseDetail(
      courseName: json['course_name'],
      lecturerName: json['lecturer_name'],
      sessions: sessions,
    );
  }
}