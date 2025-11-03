import 'Department.dart';

class Major {
  final int id;
  final String name;
  final int departmentId;
  final Department? department; 

  Major({
    required this.id,
    required this.name,
    required this.departmentId,
    this.department,
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      departmentId: int.parse(json['department_id'].toString()),
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
    );
  }
}