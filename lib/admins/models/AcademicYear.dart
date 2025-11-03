class AcademicYear {
  final int id;
  final int startYear;
  final int endYear;
  final String? startDate;
  final String? endDate;
  final bool isActive;

  AcademicYear({
    required this.id,
    required this.startYear,
    required this.endYear,
    this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      id: int.parse(json['id'].toString()),
      startYear: int.parse(json['start_year'].toString()),
      endYear: int.parse(json['end_year'].toString()),

      // Lấy dữ liệu mới, có thể null
      startDate: json['start_date'],
      endDate: json['end_date'],

      // Xử lý boolean (Backend có thể trả về 1/0 hoặc true/false)
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}