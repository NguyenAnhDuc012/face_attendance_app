import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart';
//Quản lý điểm danh
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NonSessionDetailScreen(),
  ));
}

class NonSessionDetailScreen extends StatefulWidget {
  const NonSessionDetailScreen({super.key});

  @override
  State<NonSessionDetailScreen> createState() => _NonSessionDetailScreenState();
}

class _NonSessionDetailScreenState extends State<NonSessionDetailScreen> {
  String _selectedMode = 'manual';
  int _selectedDuration = 15;
  bool _isStarting = false;
  bool _isEnding = false;

  // Mock dữ liệu session
  final Map<String, dynamic> session = {
    "courseName": "Lập trình Flutter",
    "className": "CTK45",
    "sessionDate": "2025-11-08",
    "startTime": "07:30",
    "endTime": "09:15",
    "roomName": "A202",
    "status": "pending", // Thử đổi: pending / active / closed
    "totalStudents": 35,
    "presentStudents": 28,
    "absentStudents": 7,
  };

  @override
  Widget build(BuildContext context) {
    final status = session["status"] as String;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {},
        ),
        title: const Text(
          'Quản lý điểm danh',
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
          _buildSessionInfoCard(),
          const SizedBox(height: 24),
          _buildSessionStatusBlock(status: status),
          const SizedBox(height: 24),
          _buildStatsRow(
            total: session["totalStudents"] as int,
            present: session["presentStudents"] as int,
            absent: session["absentStudents"] as int,
          ),
          const SizedBox(height: 32),
          _buildActionsSection(status),
        ],
      ),

      bottomNavigationBar: BottomTabNav(currentIndex: 3, onTap: (index) {}),
    );
  }

  Widget _buildSessionInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lớp học hiện tại', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            "${session["courseName"]} - ${session["className"]}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text("${session["sessionDate"]}"),
              const SizedBox(width: 24),
              const Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text("${session["startTime"]} - ${session["endTime"]}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text("${session["roomName"]}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStatusBlock({required String status}) {
    if (status == 'pending') {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tùy chọn điểm danh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Phương thức:'),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'manual', label: Text('Thủ công'), icon: Icon(Icons.pan_tool_outlined)),
                ButtonSegment(value: 'face_recognition_qr', label: Text('Quét QR'), icon: Icon(Icons.qr_code_scanner)),
              ],
              selected: {_selectedMode},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() => _selectedMode = newSelection.first);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thời gian:'),
                DropdownButton<int>(
                  value: _selectedDuration,
                  items: [15, 30, 45, 60, 90].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value phút'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedDuration = newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isStarting ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                child: _isStarting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Bắt đầu điểm danh', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    if (status == 'active') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isEnding ? null : () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: _isEnding
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Kết thúc điểm danh',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          'Buổi điểm danh đã kết thúc. '
              '${session["presentStudents"]}/${session["totalStudents"]} sinh viên có mặt.',
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildStatsRow({
    required int total,
    required int present,
    required int absent,
  }) {
    return Row(
      children: [
        _buildStatCard('Tổng SV', total.toString(), Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard('Đã có mặt', present.toString(), Colors.green),
        const SizedBox(width: 12),
        _buildStatCard('Vắng mặt', absent.toString(), Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(String status) {
    if (status == 'pending') return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hành động khác',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildActionRow(title: 'Xem danh sách sinh viên', actionText: 'Xem ngay', onTap: () {}),
          const Divider(height: 24),
          _buildActionRow(title: 'Điểm danh Thủ công', actionText: 'Thực hiện', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(actionText,
                  style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500)),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
