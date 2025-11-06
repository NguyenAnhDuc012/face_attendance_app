import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_course_session.dart';
import '../services/student_course_service.dart';
import '../layouts/bottom_tab_nav.dart';
import 'student_edit_attendance_screen.dart';


class StudentCourseDetailScreen extends StatefulWidget {
  final int courseId;
  final String courseName;
  final String lecturerName; // <-- Sinh viên cần tên Giảng viên

  const StudentCourseDetailScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.lecturerName, // <-- Thêm
  });

  @override
  State<StudentCourseDetailScreen> createState() =>
      _StudentCourseDetailScreenState();
}

class _StudentCourseDetailScreenState extends State<StudentCourseDetailScreen>
    with SingleTickerProviderStateMixin {
  // Hàm refresh (Sẽ cần dùng)
  void _refreshData() {
    setState(() {
      _detailFuture = StudentCourseService.getCourseDetails(widget.courseId);
    });
  }

  late TabController _tabController;
  late Future<StudentCourseDetail> _detailFuture;
  List<StudentCourseSession> _upcomingSessions = [];
  List<StudentCourseSession> _pastSessions = [];

  String _initials = ''; // Avatar
  int _bottomNavIndex = 3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Gọi service của Student
    _detailFuture = StudentCourseService.getCourseDetails(widget.courseId);
    _loadStudentInfo(); // Tải avatar
  }

  // Tải avatar
  Future<void> _loadStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('student_full_name');
    if (mounted) {
      setState(() {
        if (fullName != null && fullName.isNotEmpty) {
          _initials = fullName[0].toUpperCase();
        } else {
          _initials = '?';
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Hàm lọc (Đã cập nhật tên model)
  void _processSessionData(List<StudentCourseSession> allSessions) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _upcomingSessions = allSessions
        .where((s) =>
    s.sessionDate.isAfter(today) ||
        s.sessionDate.isAtSameMomentAs(today))
        .toList();
    _pastSessions =
        allSessions.where((s) => s.sessionDate.isBefore(today)).toList();

    _upcomingSessions.sort((a, b) => a.sessionDate.compareTo(b.sessionDate));
    _pastSessions.sort((a, b) => b.sessionDate.compareTo(a.sessionDate));
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            // Quay về màn hình danh sách (thay vì StudentHomeScreen)
            Navigator.pop(context);
          },
        ),
        // Hiển thị tên môn học và tên GIẢNG VIÊN
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courseName,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'GV: ${widget.lecturerName}', // <-- Hiển thị tên GV
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        actions: [
          // Avatar của SINH VIÊN
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue[700],
              child: _initials.isEmpty
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(_initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        // TabBar (Giữ nguyên)
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Sắp tới'),
            Tab(text: 'Đã qua'),
          ],
        ),
      ),
      // Dùng model mới
      body: FutureBuilder<StudentCourseDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu.'));
          }

          _processSessionData(snapshot.data!.sessions);

          return TabBarView(
            controller: _tabController,
            children: [
              _buildSessionList(_upcomingSessions, "Chưa có buổi học nào sắp tới."),
              _buildSessionList(_pastSessions, "Chưa có buổi học nào đã qua."),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: _bottomNavIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Build list (Dùng model mới)
  Widget _buildSessionList(List<StudentCourseSession> sessions, String emptyMessage) {
    if (sessions.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(StudentCourseSession session) {
    final String formattedDate = DateFormat('dd/MM/yyyy').format(session.sessionDate);
    final String subjectName = widget.courseName;

    // Nút "Điểm danh" chỉ bật khi buổi học 'active'
    final bool canAttend = (session.sessionStatus == 'active');
    // Và sinh viên chưa điểm danh
    final bool alreadyAttended = (session.myAttendanceStatus == 'present' ||
        session.myAttendanceStatus == 'late');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Card(
          elevation: 0.5,
          margin: const EdgeInsets.only(bottom: 12.0),
          color: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cột thông tin (Tên, Time, Room)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${session.startTime} - ${session.endTime}',
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.roomName,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Cột trạng thái (CỦA BẠN) và Nút
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Trạng thái của bạn:',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.myStatusText, // <-- Dùng trạng thái của SV
                      style: TextStyle(
                        color: session.myStatusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      // Cập nhật logic onPressed
                      onPressed: (canAttend && !alreadyAttended) ? () async {
                        // 1. KIỂM TRA MODE
                        if (session.attendanceMode == 'manual') {
                          // 2. Đi đến màn hình Sửa (Thủ công)
                          final bool? didUpdate = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentEditAttendanceScreen(
                                sessionId: session.sessionId,
                                studentName: "Sinh viên", // Tạm (lấy từ prefs nếu muốn)
                                currentStatus: session.myAttendanceStatus,
                                courseName: widget.courseName,
                                lecturerName: widget.lecturerName,
                                roomName: session.roomName,
                                sessionDate: formattedDate,
                                startTime: session.startTime,
                                endTime: session.endTime,
                              ),
                            ),
                          );
                          // 3. Nếu cập nhật thành công, tải lại list
                          if (didUpdate == true) {
                            _refreshData();
                          }
                        } else {
                          // Chế độ QR (chưa làm)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mở camera để quét QR (chưa hỗ trợ)'),
                              backgroundColor: Colors.indigo,
                            ),

                          );
                        }
                      } : null, // Vô hiệu hóa nút
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      // Đổi chữ trên nút
                      child: Text(alreadyAttended ? 'Đã điểm danh' :
                      (session.sessionStatus == 'closed' ? 'Đã kết thúc' : 'Điểm danh')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}