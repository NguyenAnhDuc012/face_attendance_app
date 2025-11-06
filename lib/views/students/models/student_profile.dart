// lib/models/student_profile.dart
class StudentProfile {
  final String fullName;
  final String email;
  final String className;
  final String? imageUrl; // Ảnh có thể null

  StudentProfile({
    required this.fullName,
    required this.email,
    required this.className,
    this.imageUrl,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      fullName: json['full_name'],
      email: json['email'],
      className: json['class_name'],
      imageUrl: json['image_url'],
    );
  }
}