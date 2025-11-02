class StudentClass {
  final int id;
  final String name;

  StudentClass({
    required this.id,
    required this.name,
  });

  factory StudentClass.fromJson(Map<String, dynamic> json) {
    return StudentClass(
      id: int.parse(json['id'].toString()),
      name: json['name'],
    );
  }
}
