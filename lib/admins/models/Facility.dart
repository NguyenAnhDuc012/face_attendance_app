class Facility {
  final int id;
  final String name;

  Facility({
    required this.id,
    required this.name,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: int.parse(json['id'].toString()),
      name: json['name'],
    );
  }
}
