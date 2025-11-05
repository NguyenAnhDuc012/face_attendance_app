// lib/screens/session_detail_screen.dart
import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart'; // Import bottom nav của bạn

class TEST extends StatefulWidget {
  // Khi bạn gọi màn hình này, bạn sẽ cần truyền ID của buổi học
  // final int sessionId;
  // final int courseId;

  const TEST({
    super.key,
    // required this.sessionId,
    // required this.courseId,
  });

  @override
  State<TEST> createState() => _TESTState();
}

// BỎ 'with SingleTickerProviderStateMixin' vì không còn TabBar
class _TESTState extends State<TEST> {
  // ----- State cho các lựa chọn -----
  // 'manual' (Thủ công) hoặc 'qr' (Quét QR)
  String _selectedMode = 'manual';

  // Thời gian điểm danh, mặc định 15 phút
  int _selectedDuration = 15;
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://placekitten.com/50/50'),
            ),
          ),
        ],
        // BỎ 'bottom: TabBar'
      ),

      // BỎ 'TabBarView', CHỈ DÙNG 1 BODY
      body: _buildSessionBody(
        // Đây là dữ liệu tĩnh để test, bạn sẽ thay bằng dữ liệu thật
        status: 'pending', // Luôn là pending cho giao diện này
        presentCount: 0,
        absentCount: 45, // Lấy từ (Tổng SV)
      ),

      bottomNavigationBar: BottomTabNav(
        currentIndex: 3, // Giả sử tab 'Lịch' là index 3
        onTap: (index) {},
      ),
    );
  }

  // Widget build nội dung chính
  Widget _buildSessionBody({
    required String status,
    required int presentCount,
    required int absentCount,
  }) {
    int totalStudents = presentCount + absentCount;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Thẻ thông tin buổi học
        _buildSessionInfoCard(),
        const SizedBox(height: 24),

        // Khối trạng thái (Đã được cập nhật)
        _buildSessionStatusBlock(
          status: status,
          presentCount: presentCount,
          totalStudents: totalStudents,
        ),
        const SizedBox(height: 24),

        // Hàng thống kê
        _buildStatsRow(
          total: totalStudents,
          present: presentCount,
          absent: absentCount,
        ),
        const SizedBox(height: 32),

        // Khối hành động khác
        _buildActionsSection(),
      ],
    );
  }

  // Thẻ thông tin buổi học (Lớp học hiện tại)
  Widget _buildSessionInfoCard() {
    // (Giữ nguyên code từ trước, không thay đổi)
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
          const Text(
            'Lớp học hiện tại',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lập trình Mobile - 64KTPM1',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // ... (Các row ngày, giờ, phòng)
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                '02/02/2026',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                '07:00 - 09:30',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                '302 - C5',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Khối Nút bấm hoặc Trạng thái (ĐÃ CẬP NHẬT)
  Widget _buildSessionStatusBlock({
    required String status,
    required int presentCount,
    required int totalStudents,
  }) {

    // BỎ IF CHO 'active' VÀ 'closed' (vì màn này chỉ là pending)

    // TRẠNG THÁI 'pending' (ĐÃ THAY ĐỔI HOÀN TOÀN)
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tùy chọn điểm danh',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 1. CHỌN PHƯƠNG THỨC
          const Text('Phương thức:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          // Dùng SegmentedButton cho giao diện đẹp
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'manual',
                label: Text('Thủ công'),
                icon: Icon(Icons.pan_tool_outlined),
              ),
              ButtonSegment(
                value: 'qr',
                label: Text('Quét QR'),
                icon: Icon(Icons.qr_code_scanner),
              ),
            ],
            selected: {_selectedMode},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedMode = newSelection.first;
              });
            },
            style: SegmentedButton.styleFrom(
              minimumSize: const Size(0, 40),
            ),
          ),
          const SizedBox(height: 16),

          // 2. CHỌN THỜI GIAN KẾT THÚC
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Thời gian:', style: TextStyle(fontSize: 16)),
              DropdownButton<int>(
                value: _selectedDuration,
                items: [
                  15,
                  30,
                  45,
                  60,
                  90,
                ].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value phút'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedDuration = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. NÚT BẮT ĐẦU
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Gọi API bắt đầu điểm danh với
                // _selectedMode và _selectedDuration
                print('Bắt đầu: Mode=$_selectedMode, Duration=$_selectedDuration phút');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Bắt đầu điểm danh',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàng thống kê 3 ô (Giữ nguyên)
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

  // Thẻ thống kê (cho 3 ô) (Giữ nguyên)
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
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Khối "Hành động khác" (Giữ nguyên)
  Widget _buildActionsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hành động khác',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionRow(
            title: 'Xem danh sách sinh viên',
            actionText: 'Xem ngay',
            onTap: () {},
          ),
          const Divider(height: 24),
          _buildActionRow(
            title: 'Điểm danh Thủ công',
            actionText: 'Thực hiện',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Một hàng trong "Hành động khác" (Giữ nguyên)
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                actionText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}