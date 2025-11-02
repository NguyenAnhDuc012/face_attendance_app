import 'AcademicYear.dart';

class Semester {
  final int id;
  final String name;
  final int academicYearId;
  final AcademicYear? academicYear;

  Semester({
    required this.id,
    required this.name,
    required this.academicYearId,
    this.academicYear,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      academicYearId: int.parse(json['academic_year_id'].toString()),
      academicYear: json['academic_year'] != null
          ? AcademicYear.fromJson(json['academic_year'])
          : null,
    );
  }
}
