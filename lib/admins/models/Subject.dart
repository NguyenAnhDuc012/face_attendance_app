import 'Department.dart';

class Subject {
  final int id;
  final String name;
  final int credits;
  final int departmentId;
  final Department? department;

  Subject({
    required this.id,
    required this.name,
    required this.credits,
    required this.departmentId,
    this.department,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      credits: int.parse(json['credits'].toString()),
      departmentId: int.parse(json['department_id'].toString()),
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
    );
  }
}