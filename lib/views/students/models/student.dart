
// Lớp phụ để lưu tên lớp
class StudentClassInfo {
  final int id;
  final String name;
  StudentClassInfo({required this.id, required this.name});
  factory StudentClassInfo.fromJson(Map<String, dynamic> json) {
    return StudentClassInfo(id: json['id'], name: json['name']);
  }
}

class Student {
  final int id;
  final String fullName;
  final String dob;
  final int classId;
  final String email;
  final String? phone;
  final StudentClassInfo? studentClass;

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
      // Nếu API trả về 'student_class' thì parse nó
      studentClass: json['student_class'] != null
          ? StudentClassInfo.fromJson(json['student_class'])
          : null,
    );
  }
}