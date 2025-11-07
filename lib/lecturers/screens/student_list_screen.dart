// lib/screens/student_list_screen.dart
import 'package:face_attendance_app/lecturers/screens/edit_attendance_screen.dart';
import 'package:face_attendance_app/lecturers/screens/session_detail_screen.dart';
import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart';
import '../model/student_attendance_record.dart';
import '../services/session_service.dart';

class StudentListScreen extends StatefulWidget {
  // Thông tin nhận từ màn hình trước
  final int sessionId;
  final String courseName;
  final String className;
  final String roomName;
  final String sessionDate;
  final String startTime;
  final String endTime;
  final int courseId;

  const StudentListScreen({
    super.key,
    required this.sessionId,
    required this.courseName,
    required this.className,
    required this.roomName,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.courseId,
  });

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<StudentAttendanceRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh sách records
    _recordsFuture = SessionService.getAttendanceRecords(widget.sessionId);
  }

  // Hàm để refresh lại
  void _refreshData() {
    setState(() {
      _recordsFuture = SessionService.getAttendanceRecords(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                // 1. Bỏ 'const'
                builder: (context) => SessionDetailScreen(
                  // 2. Dùng 'widget.' để truy cập
                  sessionId: widget.sessionId,
                  courseId: widget.courseId,
                  courseName: widget.courseName,
                  className: widget.className,
                ),
              ),
            );
          },
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
      body: FutureBuilder<List<StudentAttendanceRecord>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Danh sách sinh viên trống.'));
          }

          final records = snapshot.data!;

          // Dùng ListView
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Thẻ thông tin Lớp học (giống màn hình trước)
              _buildClassInfoCard(),
              const SizedBox(height: 24),
              // 2. Danh sách sinh viên
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return _buildStudentRecordCard(records[index]);
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: 3, // Giả sử tab 'Lịch' là index 3
        onTap: (index) {},
      ),
    );
  }

  // Thẻ thông tin buổi học (giống layout ảnh)
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
          const Text(
            'Lớp học hiện tại',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.courseName} - ${widget.className}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                widget.sessionDate,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Text(
                '${widget.startTime} - ${widget.endTime}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                widget.roomName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Thẻ thông tin 1 sinh viên (giống layout ảnh)
  Widget _buildStudentRecordCard(StudentAttendanceRecord record) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12.0),
      // Viền màu xanh lá
      shape: RoundedRectangleBorder(
        side: BorderSide(color: record.statusColor, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cột Tên và MSSV
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.studentName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mã sinh viên: ${record.studentCode}', // Sửa ở dòng này
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            // Cột Trạng thái và Nút
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  record.statusText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: record.statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Chỉ hiển thị giờ nếu đã check-in
                if (record.checkInTime != null)
                  Text(
                    'Lúc ${record.checkInTime}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    // 1. Điều hướng và chờ kết quả
                    final bool? didUpdate = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAttendanceScreen(
                          // Truyền dữ liệu chi tiết
                          recordId: record.recordId,
                          studentName: record.studentName,
                          studentCode: record.studentCode.toString(),
                          currentStatus: record.status,
                          // Truyền thông tin header
                          courseName: widget.courseName,
                          className: widget.className,
                          roomName: widget.roomName,
                          sessionDate: widget.sessionDate,
                          startTime: widget.startTime,
                          endTime: widget.endTime,
                        ),
                      ),
                    );

                    // 2. Nếu kết quả trả về là true (đã cập nhật)
                    if (didUpdate == true) {
                      _refreshData(); // Làm mới lại danh sách
                    }
                  },
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