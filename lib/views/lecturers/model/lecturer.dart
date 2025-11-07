class Lecturer {
  final int id;
  final String fullName;
  final int facultyId;
  final String email;
  final String? phone;
  final String createdAt;

  Lecturer({
    required this.id,
    required this.fullName,
    required this.facultyId,
    required this.email,
    this.phone,
    required this.createdAt,
  });

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      id: int.parse(json['id'].toString()),
      fullName: json['full_name'],
      facultyId: int.parse(json['faculty_id'].toString()),
      email: json['email'],
      phone: json['phone'],
      createdAt: json['created_at'].toString(),
    );
  }
}