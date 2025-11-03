import 'Faculty.dart';

class Lecturer {
  final int id;
  final String fullName;
  final int facultyId;
  final String email;
  final String? phone;
  final Faculty? faculty;

  Lecturer({
    required this.id,
    required this.fullName,
    required this.facultyId,
    required this.email,
    this.phone,
    this.faculty,
  });

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      id: int.parse(json['id'].toString()),
      fullName: json['full_name'], 
      facultyId: int.parse(json['faculty_id'].toString()),
      email: json['email'],
      phone: json['phone'],
      faculty: json['faculty'] != null
          ? Faculty.fromJson(json['faculty'])
          : null,
    );
  }
}