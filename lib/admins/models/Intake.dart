// Khóa học
class Intake {
  final int id;
  final String name;
  final int startYear;
  final int expectedGraduationYear;

  Intake({
    required this.id,
    required this.name,
    required this.startYear,
    required this.expectedGraduationYear,
  });

  factory Intake.fromJson(Map<String, dynamic> json) {
    return Intake(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      startYear: int.parse(json['start_year'].toString()),
      expectedGraduationYear:
      int.parse(json['expected_graduation_year'].toString()),
    );
  }
}