import 'Facility.dart';

class Faculty {
  final int id;
  final String name;
  final int facilityId;
  final Facility? facility;

  Faculty({
    required this.id,
    required this.name,
    required this.facilityId,
    this.facility,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      facilityId: int.parse(json['facility_id'].toString()),
      facility: json['facility'] != null ? Facility.fromJson(json['facility']) : null,
    );
  }
}
