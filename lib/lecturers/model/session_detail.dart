class SessionDetail {
  final int sessionId;
  final String courseName;
  final String className;
  final String roomName;
  final String sessionDate;
  final String startTime;
  final String endTime;
  final String status;
  final int totalStudents;
  final int presentStudents;
  final int absentStudents;

  SessionDetail({
    required this.sessionId,
    required this.courseName,
    required this.className,
    required this.roomName,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalStudents,
    required this.presentStudents,
    required this.absentStudents,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) {
    return SessionDetail(
      sessionId: json['session_id'],
      courseName: json['course_name'],
      className: json['class_name'],
      roomName: json['room_name'],
      sessionDate: json['session_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      totalStudents: json['total_students'],
      presentStudents: json['present_students'],
      absentStudents: json['absent_students'],
    );
  }
}