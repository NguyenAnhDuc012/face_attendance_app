import 'Faculty.dart';

class Department {
  final int id;
  final String name;
  final int facultyId;
  final Faculty? faculty; 

  Department({
    required this.id,
    required this.name,
    required this.facultyId,
    this.faculty,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      facultyId: int.parse(json['faculty_id'].toString()),
      faculty: json['faculty'] != null
          ? Faculty.fromJson(json['faculty'])
          : null,
    );
  }
}