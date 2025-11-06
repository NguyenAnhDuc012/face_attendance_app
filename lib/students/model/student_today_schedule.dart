// lib/models/student_today_schedule.dart
class StudentTodaySchedule {
  final int sessionId;
  final int courseId;
  final String subjectName;
  final String lecturerName;
  final String roomName;
  final String startTime;
  final String endTime;
  final String sessionStatus; // 'pending', 'active', 'closed'
  final String myAttendanceStatus; // 'present', 'absent', 'late', 'chưa có'

  StudentTodaySchedule({
    required this.sessionId,
    required this.courseId,
    required this.subjectName,
    required this.lecturerName,
    required this.roomName,
    required this.startTime,
    required this.endTime,
    required this.sessionStatus,
    required this.myAttendanceStatus,
  });

  factory StudentTodaySchedule.fromJson(Map<String, dynamic> json) {
    return StudentTodaySchedule(
      sessionId: json['session_id'],
      courseId: json['course_id'],
      subjectName: json['subject_name'],
      lecturerName: json['lecturer_name'],
      roomName: json['room_name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      sessionStatus: json['session_status'],
      myAttendanceStatus: json['my_attendance_status'],
    );
  }
}