// lib/screens/student_edit_attendance_screen.dart
import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart';
import '../services/student_attendance_service.dart'; // <-- Service mới

class StudentEditAttendanceScreen extends StatefulWidget {
  // Dữ liệu nhận từ màn hình trước
  final int sessionId;
  final String studentName;
  final String currentStatus;
  // Info cho header
  final String courseName;
  final String lecturerName;
  final String roomName;
  final String sessionDate;
  final String startTime;
  final String endTime;

  const StudentEditAttendanceScreen({
    super.key,
    required this.sessionId,
    required this.studentName,
    required this.currentStatus,
    required this.courseName,
    required this.lecturerName,
    required this.roomName,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<StudentEditAttendanceScreen> createState() =>
      _StudentEditAttendanceScreenState();
}

class _StudentEditAttendanceScreenState
    extends State<StudentEditAttendanceScreen> {
  late String _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Gán trạng thái hiện tại (có thể là 'absent' hoặc 'chưa có')
    _selectedStatus = widget.currentStatus == 'chưa có'
        ? 'present' // Mặc định chọn 'Có mặt'
        : widget.currentStatus;
  }

  // Hàm gọi API khi nhấn Xác nhận
  Future<void> _confirmUpdate() async {
    setState(() => _isLoading = true);

    try {
      // Gọi service của Student
      await StudentAttendanceService.submitAttendance(
        sessionId: widget.sessionId,
        newStatus: _selectedStatus,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Điểm danh thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Trở về và báo thành công
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(false), // Pop 'false'
        ),
        title: const Text('Điểm danh Thủ công'),
        // ... (actions)
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

          // Các lựa chọn (Bỏ 'Vắng')
          _buildStatusOptionTile(
            title: 'Có mặt',
            subtitle: 'Bạn có mặt tại lớp',
            value: 'present',
            color: Colors.green,
          ),
          _buildStatusOptionTile(
            title: 'Muộn',
            subtitle: 'Bạn có mặt tại lớp (trễ)',
            value: 'late',
            color: Colors.orange,
          ),
          // (Sinh viên không nên tự chọn 'Vắng' hoặc 'Có phép')

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
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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

  // Widget cho Thẻ Header (dữ liệu từ widget)
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
          Text(
            widget.studentName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.courseName} (GV: ${widget.lecturerName})',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ngày: ${widget.sessionDate}', style: const TextStyle(fontSize: 14)),
              Text('${widget.startTime} - ${widget.endTime}', style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Phòng: ${widget.roomName}', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Widget cho 1 ô lựa chọn (RadioListTile)
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
        onTap: () {
          setState(() {
            _selectedStatus = value;
          });
        },
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
                    Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: _selectedStatus,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() { _selectedStatus = newValue; });
                  }
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