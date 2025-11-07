// lib/models/course_group.dart

// Model cho từng lớp học phần (course)
class SimpleCourse {
  final int id;
  final String subjectName;
  final String className;

  SimpleCourse({
    required this.id,
    required this.subjectName,
    required this.className,
  });

  factory SimpleCourse.fromJson(Map<String, dynamic> json) {
    return SimpleCourse(
      id: json['id'],
      subjectName: json['subject_name'],
      className: json['class_name'],
    );
  }
}

// Model cho nhóm (Đợt học)
class StudyPeriodGroup {
  final int id;
  final String startDate;
  final String endDate;
  final List<SimpleCourse> courses;

  StudyPeriodGroup({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.courses,
  });

  factory StudyPeriodGroup.fromJson(Map<String, dynamic> json) {
    // Chuyển đổi danh sách JSON của 'courses' thành List<SimpleCourse>
    var courseList = json['courses'] as List;
    List<SimpleCourse> courses =
    courseList.map((i) => SimpleCourse.fromJson(i)).toList();

    return StudyPeriodGroup(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      courses: courses,
    );
  }
}