import 'package:flutter/material.dart';

class StudentAttendanceRecord {
  final int recordId;
  final int studentId;
  final String studentName;
  final int studentCode;
  final String status; // 'present', 'absent', 'late'
  final String? checkInTime; // 'HH:mm' hoặc null

  StudentAttendanceRecord({
    required this.recordId,
    required this.studentId,
    required this.studentName,
    required this.studentCode,
    required this.status,
    this.checkInTime,
  });

  factory StudentAttendanceRecord.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceRecord(
      recordId: json['record_id'],
      studentId: json['student_id'],
      studentName: json['student_name'],
      studentCode: json['student_code'],
      status: json['status'],
      checkInTime: json['check_in_time'],
    );
  }

  // Helper để lấy text cho trạng thái (giống trong ảnh)
  String get statusText {
    switch (status) {
      case 'present':
        return 'Có mặt';
      case 'late':
        return 'Có mặt (Trễ)';
      case 'absent':
        return 'Vắng mặt';
      case 'excused':
        return 'Vắng (Có phép)';
      default:
        return 'N/A';
    }
  }

  // Helper để lấy màu cho trạng thái (giống trong ảnh)
  Color get statusColor {
    switch (status) {
      case 'present':
      case 'late':
        return Colors.green; // Màu xanh lá
      case 'absent':
        return Colors.red;
      case 'excused':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}