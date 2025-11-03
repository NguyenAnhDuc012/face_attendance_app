import 'Subject.dart';
import 'StudentClass.dart';
import 'StudyPeriod.dart';
import 'Lecturer.dart';

class Course {
  final int id;
  final int subjectId;
  final int classId;
  final int studyPeriodId;
  final int lecturerId;

  // Dữ liệu lồng
  final Subject? subject;
  final StudentClass? studentClass;
  final StudyPeriod? studyPeriod;
  final Lecturer? lecturer;

  Course({
    required this.id,
    required this.subjectId,
    required this.classId,
    required this.studyPeriodId,
    required this.lecturerId,
    this.subject,
    this.studentClass,
    this.studyPeriod,
    this.lecturer,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: int.parse(json['id'].toString()),
      subjectId: int.parse(json['subject_id'].toString()),
      classId: int.parse(json['class_id'].toString()),
      studyPeriodId: int.parse(json['study_period_id'].toString()),
      lecturerId: int.parse(json['lecturer_id'].toString()),

      // 'student_class' là key JSON trả về từ 'studentClass'
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      studentClass: json['student_class'] != null ? StudentClass.fromJson(json['student_class']) : null,
      studyPeriod: json['study_period'] != null ? StudyPeriod.fromJson(json['study_period']) : null,
      lecturer: json['lecturer'] != null ? Lecturer.fromJson(json['lecturer']) : null,
    );
  }
}