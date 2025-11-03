import 'Semester.dart';

class StudyPeriod {
  final int id;
  final String name;
  final int semesterId;
  final Semester? semester; 

  StudyPeriod({
    required this.id,
    required this.name,
    required this.semesterId,
    this.semester,
  });

  factory StudyPeriod.fromJson(Map<String, dynamic> json) {
    return StudyPeriod(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      semesterId: int.parse(json['semester_id'].toString()),
      semester: json['semester'] != null
          ? Semester.fromJson(json['semester'])
          : null,
    );
  }
}