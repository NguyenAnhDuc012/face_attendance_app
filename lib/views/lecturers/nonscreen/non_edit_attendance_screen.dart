// lib/screens/edit_attendance_screen.dart
import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart';
//Trạng thái điểm danh
class EditAttendanceScreen extends StatefulWidget {
  final int recordId;
  final String studentName;
  final String studentCode;
  final String currentStatus;
  final String courseName;
  final String className;
  final String roomName;
  final String sessionDate;
  final String startTime;
  final String endTime;

  const EditAttendanceScreen({
    super.key,
    required this.recordId,
    required this.studentName,
    required this.studentCode,
    required this.currentStatus,
    required this.courseName,
    required this.className,
    required this.roomName,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<EditAttendanceScreen> createState() => _EditAttendanceScreenState();
}

class _EditAttendanceScreenState extends State<EditAttendanceScreen> {
  late String _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  // ✅ Bỏ hết phần API — chỉ giữ giao diện mô phỏng
  Future<void> _confirmUpdate() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // mô phỏng chờ
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã chọn trạng thái: $_selectedStatus'),
          backgroundColor: Colors.blue,
        ),
      );
      setState(() => _isLoading = false);
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
        elevation: 1,
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
          _buildHeaderCard(),
          const SizedBox(height: 24),

          const Text(
            'Chọn trạng thái điểm danh cho buổi học:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          _buildStatusOptionTile(
              title: 'Có mặt',
              subtitle: 'Bạn có mặt tại lớp',
              value: 'present',
              color: Colors.green),
          _buildStatusOptionTile(
              title: 'Muộn',
              subtitle: 'Bạn có mặt tại lớp (trễ)',
              value: 'late',
              color: Colors.orange),
          _buildStatusOptionTile(
              title: 'Vắng',
              subtitle: 'Bạn không có mặt tại lớp',
              value: 'absent',
              color: Colors.red),
          _buildStatusOptionTile(
              title: 'Vắng (Có phép)',
              subtitle: 'Bạn đã xin phép vắng',
              value: 'excused',
              color: Colors.blueGrey),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _confirmUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child:
              CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text(
              'Xác nhận',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: 3,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.studentName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${widget.courseName} - ${widget.className}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ngày: ${widget.sessionDate}', style: const TextStyle(fontSize: 14)),
              Text('${widget.startTime} - ${widget.endTime}',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Phòng: ${widget.roomName}', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatusOptionTile({
    required String title,
    required String subtitle,
    required String value,
    required Color color,
  }) {
    final bool isSelected = (_selectedStatus == value);

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12.0),
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedStatus = value),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: _selectedStatus,
                onChanged: (String? newValue) {
                  if (newValue != null) setState(() => _selectedStatus = newValue);
                },
                activeColor: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================
//  👇 Giao diện tĩnh độc lập
// ==========================
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditAttendanceScreen(
      recordId: 1,
      studentName: 'Nguyễn Văn A',
      studentCode: 'SV001',
      currentStatus: 'present',
      courseName: 'Lập trình Flutter',
      className: 'CTK45',
      roomName: 'A202',
      sessionDate: '2025-11-08',
      startTime: '07:30',
      endTime: '09:15',
    ),
  ));
}
