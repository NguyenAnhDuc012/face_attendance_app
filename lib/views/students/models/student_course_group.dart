
// Model cho từng lớp học phần (Course)
class StudentSimpleCourse {
  final int id;
  final String subjectName;
  final String lecturerName; // <-- Khác với giảng viên (lấy tên GV)

  StudentSimpleCourse({
    required this.id,
    required this.subjectName,
    required this.lecturerName,
  });

  factory StudentSimpleCourse.fromJson(Map<String, dynamic> json) {
    return StudentSimpleCourse(
      id: json['id'],
      subjectName: json['subject_name'],
      lecturerName: json['lecturer_name'],
    );
  }
}

// Model cho nhóm (Đợt học)
class StudentStudyPeriodGroup {
  final int id;
  final String startDate;
  final String endDate;
  final List<StudentSimpleCourse> courses;

  StudentStudyPeriodGroup({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.courses,
  });

  factory StudentStudyPeriodGroup.fromJson(Map<String, dynamic> json) {
    var courseList = json['courses'] as List;
    // Dùng model StudentSimpleCourse
    List<StudentSimpleCourse> courses =
    courseList.map((i) => StudentSimpleCourse.fromJson(i)).toList();

    return StudentStudyPeriodGroup(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      courses: courses,
    );
  }
}