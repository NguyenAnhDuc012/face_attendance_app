import 'Semester.dart';

class StudyPeriod {
  final int id;
  final String name;
  final int semesterId;
  final Semester? semester;
  final String? startDate;
  final String? endDate;
  final bool isActive;

  StudyPeriod({
    required this.id,
    required this.name,
    required this.semesterId,
    this.semester,
    this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory StudyPeriod.fromJson(Map<String, dynamic> json) {
    return StudyPeriod(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      semesterId: int.parse(json['semester_id'].toString()),
      semester: json['semester'] != null
          ? Semester.fromJson(json['semester'])
          : null,
      startDate: json['start_date'],
      endDate: json['end_date'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}