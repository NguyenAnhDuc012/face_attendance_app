class TodaySchedule {
  final int scheduleId;
  final int? sessionId;
  final int courseId;
  final String subjectName;
  final String roomName;
  final String className;
  final String startTime;
  final String endTime;
  final int presentCount;
  final int totalStudents;
  final String status; // 'pending', 'active', 'closed'

  TodaySchedule({
    required this.scheduleId,
    this.sessionId,
    required this.courseId,
    required this.subjectName,
    required this.roomName,
    required this.className,
    required this.startTime,
    required this.endTime,
    required this.presentCount,
    required this.totalStudents,
    required this.status,
  });

  factory TodaySchedule.fromJson(Map<String, dynamic> json) {
    return TodaySchedule(
      scheduleId: json['schedule_id'],
      sessionId: json['session_id'],
      courseId: json['course_id'],
      subjectName: json['subject_name'],
      roomName: json['room_name'],
      className: json['class_name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      presentCount: json['present_count'],
      totalStudents: json['total_students'],
      status: json['status'],
    );
  }
}