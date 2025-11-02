class Admin {
  final int id;
  final String email;
  final String createdAt;

  Admin({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: int.parse(json['id'].toString()),
      email: json['email'],
      createdAt: json['created_at'].toString(),
    );
  }
}
