// models/AcademicYear.dart
class AcademicYear {
  final int id;
  final int startYear;
  final int endYear;

  AcademicYear({
    required this.id,
    required this.startYear,
    required this.endYear,
  });

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      id: int.parse(json['id'].toString()),
      startYear: int.parse(json['start_year'].toString()),
      endYear: int.parse(json['end_year'].toString()),
    );
  }
}
