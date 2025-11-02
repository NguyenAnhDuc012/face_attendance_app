class Room {
  final int id;
  final String name;

  Room({
    required this.id,
    required this.name,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: int.parse(json['id'].toString()),
      name: json['name'],
    );
  }
}
