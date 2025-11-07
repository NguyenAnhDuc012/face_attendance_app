// lib/lecturers/nonscreen/non_student_list_screen.dart
import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NonStudentListScreen(),
  ));
}

class NonStudentListScreen extends StatefulWidget {
  const NonStudentListScreen({super.key});

  @override
  State<NonStudentListScreen> createState() => _NonStudentListScreenState();
}

class _NonStudentListScreenState extends State<NonStudentListScreen> {
  // Mock dữ liệu lớp
  final classInfo = {
    "courseName": "Lập trình Flutter",
    "className": "CTK45",
    "roomName": "A202",
    "sessionDate": "2025-11-08",
    "startTime": "07:30",
    "endTime": "09:15",
  };

  // Mock danh sách sinh viên
  final List<Map<String, dynamic>> records = [
    {
      "studentName": "Nguyễn Văn A",
      "studentCode": "CTK45A001",
      "status": "present",
      "checkInTime": "07:32",
    },
    {
      "studentName": "Trần Thị B",
      "studentCode": "CTK45A002",
      "status": "absent",
      "checkInTime": null,
    },
    {
      "studentName": "Lê Minh C",
      "studentCode": "CTK45A003",
      "status": "late",
      "checkInTime": "07:45",
    },
    {
      "studentName": "Phạm Quốc D",
      "studentCode": "CTK45A004",
      "status": "present",
      "checkInTime": "07:35",
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'present':
        return "Có mặt";
      case 'late':
        return "Đi muộn";
      case 'absent':
        return "Vắng";
      default:
        return "Không rõ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {},
        ),
        title: const Text(
          'Điểm danh',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://placekitten.com/50/50'),
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildClassInfoCard(),
          const SizedBox(height: 24),
          ...records.map((record) => _buildStudentRecordCard(record)).toList(),
        ],
      ),

      bottomNavigationBar: BottomTabNav(currentIndex: 3, onTap: (index) {}),
    );
  }

  Widget _buildClassInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lớp học hiện tại',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            '${classInfo["courseName"]} - ${classInfo["className"]}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                classInfo["sessionDate"]!,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Text(
                '${classInfo["startTime"]} - ${classInfo["endTime"]}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                classInfo["roomName"]!,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRecordCard(Map<String, dynamic> record) {
    final color = _statusColor(record["status"]);
    final statusText = _statusText(record["status"]);

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cột trái: thông tin sinh viên
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record["studentName"],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mã sinh viên: ${record["studentCode"]}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            // Cột phải: trạng thái + nút
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                if (record["checkInTime"] != null)
                  Text(
                    'Lúc ${record["checkInTime"]}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Sửa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
