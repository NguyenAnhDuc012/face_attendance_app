import 'StudentClass.dart';

class Student {
  final int id;
  final String fullName;
  final String dob; // Lưu trữ dưới dạng String (ví dụ: 'YYYY-MM-DD')
  final int classId;
  final String email;
  final String? phone;
  final StudentClass? studentClass; // Đối tượng lớp lồng nhau

  Student({
    required this.id,
    required this.fullName,
    required this.dob,
    required this.classId,
    required this.email,
    this.phone,
    this.studentClass,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: int.parse(json['id'].toString()),
      fullName: json['full_name'],
      dob: json['dob'],
      classId: int.parse(json['class_id'].toString()),
      email: json['email'],
      phone: json['phone'],
      studentClass: json['student_class'] != null
          ? StudentClass.fromJson(json['student_class'])
          : null,
    );
  }
}