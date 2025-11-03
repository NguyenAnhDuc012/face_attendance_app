import 'AcademicYear.dart';

class Semester {
  final int id;
  final String name;
  final int academicYearId;
  final AcademicYear? academicYear;
  final String? startDate;
  final String? endDate;
  final bool isActive;

  Semester({
    required this.id,
    required this.name,
    required this.academicYearId,
    this.academicYear,
    this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      academicYearId: int.parse(json['academic_year_id'].toString()),
      academicYear: json['academic_year'] != null
          ? AcademicYear.fromJson(json['academic_year'])
          : null,
      startDate: json['start_date'],
      endDate: json['end_date'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}