// lib/screens/session_detail_screen.dart
import 'package:face_attendance_app/lecturers/screens/course_detail_screen.dart';
import 'package:face_attendance_app/lecturers/screens/student_list_screen.dart';
import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart';
import '../model/session_detail.dart';
import '../services/session_service.dart';
import 'qr_code_screen.dart';

class SessionDetailScreen extends StatefulWidget {
  final int sessionId;

  final int courseId;
  final String courseName;
  final String className;

  const SessionDetailScreen({
    super.key,
    required this.sessionId,
    required this.courseId,
    required this.courseName,
    required this.className,
  });

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  // State cho các lựa chọn
  String _selectedMode = 'manual';
  int _selectedDuration = 15;

  // State cho Future
  late Future<SessionDetail> _sessionDetailFuture;

  // State cho nút "Bắt đầu"
  bool _isStarting = false;

  // kết thúc
  bool _isEnding = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu chi tiết khi màn hình được mở
    _sessionDetailFuture = SessionService.getSessionDetails(widget.sessionId);
  }

  // Hàm gọi API bắt đầu
  Future<void> _startSession() async {
    setState(() => _isLoading = true);

    // 1. Lấy dữ liệu (để truyền sang màn hình QR)
    final sessionData = await _sessionDetailFuture;

    try {
      // 2. Gọi service (giờ nó trả về String?)
      final String? qrToken = await SessionService.startAttendance(
        sessionId: widget.sessionId,
        mode: _selectedMode,
        duration: _selectedDuration,
      );

      if (mounted) {
        // 3. KIỂM TRA: Nếu là chế độ QR, điều hướng
        if (qrToken != null) {
          Navigator.pushReplacement( // Dùng Replacement để thay thế màn hình này
            context,
            MaterialPageRoute(
              builder: (context) => QrCodeScreen(
                qrToken: qrToken,
                sessionDetail: sessionData, // Truyền thông tin buổi học
                durationMinutes: _selectedDuration, // Truyền thời gian
              ),
            ),
          );
        } else {
          // 4. Nếu là chế độ Thủ công, chỉ refresh
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã bắt đầu điểm danh (Thủ công)!'),
              backgroundColor: Colors.green,
            ),
          );
          // Tải lại (sẽ thấy trạng thái 'active')
          setState(() {
            _sessionDetailFuture = SessionService.getSessionDetails(widget.sessionId);
          });
        }
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

  // GỌI API KẾT THÚC =====
  Future<void> _endSession() async {
    // Hiển thị dialog xác nhận
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text(
          'Bạn có chắc chắn muốn kết thúc buổi điểm danh này?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Kết thúc'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return; // Người dùng nhấn Hủy
    }

    // Người dùng đồng ý, bắt đầu gọi API
    setState(() => _isEnding = true);

    try {
      await SessionService.endAttendance(sessionId: widget.sessionId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã kết thúc buổi điểm danh.'),
            backgroundColor: Colors.blue, // Màu xanh (thành công)
          ),
        );
      }

      // Tải lại dữ liệu (để cập nhật trạng thái sang 'closed')
      setState(() {
        _sessionDetailFuture = SessionService.getSessionDetails(
          widget.sessionId,
        );
      });
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
        setState(() => _isEnding = false);
      }
    }
  }
  // ===================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            // Dùng pushReplacement như bạn yêu cầu
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(
                  courseId: widget.courseId,
                  courseName: widget.courseName,
                  className: widget.className,
                ),
              ),
            );
          },
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
              backgroundImage: NetworkImage('https://picsum.photos/100/100'),
            ),
          ),
        ],
      ),

      // SỬ DỤNG FutureBuilder ĐỂ TẢI DỮ LIỆU
      body: FutureBuilder<SessionDetail>(
        future: _sessionDetailFuture,
        builder: (context, snapshot) {
          // 1. Đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Bị lỗi
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Lỗi tải dữ liệu: ${snapshot.error.toString().replaceFirst('Exception: ', '')}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // 3. Có dữ liệu
          if (snapshot.hasData) {
            final session = snapshot.data!;

            // Truyền dữ liệu thật vào các widget
            return _buildSessionBody(
              session: session,
              status: session.status,
              presentCount: session.presentStudents,
              absentCount: session.absentStudents,
              totalStudents: session.totalStudents,
            );
          }

          // 4. Trường hợp không mong muốn
          return const Center(child: Text('Không có dữ liệu.'));
        },
      ),

      bottomNavigationBar: BottomTabNav(currentIndex: 3, onTap: (index) {}),
    );
  }

  // Widget build nội dung chính
  Widget _buildSessionBody({
    required SessionDetail session, // <-- Nhận cả đối tượng
    required String status,
    required int presentCount,
    required int absentCount,
    required int totalStudents,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSessionInfoCard(session), // <-- Truyền session
        const SizedBox(height: 24),
        _buildSessionStatusBlock(
          status: status,
          presentCount: presentCount,
          totalStudents: totalStudents,
        ),
        const SizedBox(height: 24),
        _buildStatsRow(
          total: totalStudents,
          present: presentCount,
          absent: absentCount,
        ),
        const SizedBox(height: 32),
        _buildActionsSection(session, status), // <-- Truyền status
      ],
    );
  }

  // Thẻ thông tin buổi học (ĐÃ CẬP NHẬT)
  Widget _buildSessionInfoCard(SessionDetail session) {
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
          Text(
            '${session.courseName} - ${session.className}', // Dữ liệu thật
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                session.sessionDate, // Dữ liệu thật
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 24),
              const Icon(
                Icons.access_time_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                '${session.startTime} - ${session.endTime}', // Dữ liệu thật
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                session.roomName, // Dữ liệu thật
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
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
    // TRẠNG THÁI 1: CHƯA DIỄN RA ('pending')
    if (status == 'pending') {
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Phương thức:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'manual',
                  label: Text('Thủ công'),
                  icon: Icon(Icons.pan_tool_outlined),
                ),
                ButtonSegment(
                  value: 'face_recognition_qr',
                  label: Text('Quét QR'),
                  icon: Icon(Icons.qr_code_scanner),
                ),
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
                const Text('Thời gian:', style: TextStyle(fontSize: 16)),
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
                // Vô hiệu hóa nút khi đang tải
                onPressed: _isLoading ? null : _startSession,
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
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Bắt đầu điểm danh',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    }

    // TRẠNG THÁI 2: ĐANG DIỄN RA ('active')
    if (status == 'active') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isEnding ? null : _endSession,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: _isEnding
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Kết thúc điểm danh',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      );
    }

    // TRẠNG THÁI 3: ĐÃ KẾT THÚC ('closed')
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          'Buổi điểm danh đã kết thúc. $presentCount/$totalStudents sinh viên có mặt.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
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
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  // Khối "Hành động khác" (CẬP NHẬT: Ẩn nếu chưa bắt đầu)
  Widget _buildActionsSection(SessionDetail session, String status) {
    // Chỉ hiển thị khi buổi học đang 'active' hoặc 'closed'
    if (status == 'pending') {
      return const SizedBox.shrink(); // Trả về widget rỗng
    }

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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActionRow(
            title: 'Xem danh sách sinh viên',
            actionText: 'Xem ngay',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentListScreen(
                    // Truyền toàn bộ thông tin cần thiết
                    sessionId: session.sessionId,
                    courseName: session.courseName,
                    className: session.className,
                    roomName: session.roomName,
                    sessionDate: session.sessionDate,
                    startTime: session.startTime,
                    endTime: session.endTime,
                    courseId: widget.courseId,
                  ),
                ),
              );
            },
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blue,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
