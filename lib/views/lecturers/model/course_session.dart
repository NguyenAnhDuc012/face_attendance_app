// lib/models/course_session.dart
import 'package:flutter/material.dart';

// Model cho một buổi học (Session)
class CourseSession {
  final int sessionId;
  final DateTime sessionDate; // Dùng DateTime để so sánh
  final String startTime;
  final String endTime;
  final String roomName;
  final int presentCount;
  final int totalStudents;
  final String status; // 'pending', 'active', 'closed'

  CourseSession({
    required this.sessionId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.roomName,
    required this.presentCount,
    required this.totalStudents,
    required this.status,
  });

  factory CourseSession.fromJson(Map<String, dynamic> json) {
    final parts = (json['session_date'] as String).split('-');
    final DateTime sessionDate = DateTime(
      int.parse(parts[0]), // Năm
      int.parse(parts[1]), // Tháng
      int.parse(parts[2]), // Ngày
    );

    return CourseSession(
      sessionId: json['session_id'],
      sessionDate: sessionDate, // Sử dụng ngày đã parse đúng
      startTime: json['start_time'],
      endTime: json['end_time'],
      roomName: json['room_name'],
      presentCount: json['present_count'],
      totalStudents: json['total_students'],
      status: json['status'],
    );
  }

  // Helper để lấy text cho trạng thái
  String get statusText {
    switch (status) {
      case 'active':
        return 'Đang diễn ra';
      case 'closed':
        return 'Đã kết thúc';
      case 'pending':
      default:
        return 'Chưa diễn ra';
    }
  }

  // Helper để lấy màu cho trạng thái
  Color get statusColor {
    switch (status) {
      case 'active':
        return Colors.blue;
      case 'closed':
        return Colors.green;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}

// Model cho toàn bộ màn hình (AppBar + List)
class CourseDetail {
  final String courseName;
  final String className;
  final List<CourseSession> sessions;

  CourseDetail({
    required this.courseName,
    required this.className,
    required this.sessions,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    var sessionList = json['sessions'] as List;
    List<CourseSession> sessions = sessionList
        .map((i) => CourseSession.fromJson(i))
        .toList();

    return CourseDetail(
      courseName: json['course_name'],
      className: json['class_name'],
      sessions: sessions,
    );
  }
}
