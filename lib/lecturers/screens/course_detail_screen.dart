// lib/screens/course_detail_screen.dart
import 'package:face_attendance_app/lecturers/screens/course_list_screen.dart';
import 'package:face_attendance_app/lecturers/screens/session_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Cần thêm thư viện intl: flutter pub add intl
import '../model/course_session.dart';
import '../services/course_service.dart';
import '../layouts/bottom_tab_nav.dart'; // Import bottom nav

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  final String courseName;
  final String className;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.className,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late Future<CourseDetail> _detailFuture;

  List<CourseSession> _upcomingSessions = [];
  List<CourseSession> _pastSessions = [];

  int _bottomNavIndex = 3; // Giả sử tab 'Lịch' là index 3

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _detailFuture = CourseService.getCourseDetails(widget.courseId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Hàm lọc và sắp xếp dữ liệu
  void _processSessionData(List<CourseSession> allSessions) {
    // Lấy ngày hôm nay (chỉ ngày, không lấy giờ)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _upcomingSessions = allSessions
        .where((s) =>
    s.sessionDate.isAfter(today) ||
        s.sessionDate.isAtSameMomentAs(today))
        .toList();

    _pastSessions =
        allSessions.where((s) => s.sessionDate.isBefore(today)).toList();

    // Sắp tới: Tăng dần (ASC)
    _upcomingSessions.sort((a, b) => a.sessionDate.compareTo(b.sessionDate));

    // Đã qua: Giảm dần (DESC)
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CourseListScreen()),
            );
          },
        ),
        // Hiển thị tên lớp và môn học trên AppBar
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courseName,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18, // Giảm size chút
              ),
            ),
            Text(
              widget.className,
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://picsum.photos/100/100'),
            ),
          ),
        ],
        // TabBar
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
      body: FutureBuilder<CourseDetail>(
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

          // Lọc và sắp xếp dữ liệu
          _processSessionData(snapshot.data!.sessions);

          // Hiển thị TabBarView
          return TabBarView(
            controller: _tabController,
            children: [
              // Tab Sắp tới
              _buildSessionList(_upcomingSessions, "Chưa có buổi học nào sắp tới."),
              // Tab Đã qua
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

  // Widget build danh sách buổi học
  Widget _buildSessionList(List<CourseSession> sessions, String emptyMessage) {
    if (sessions.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    // Dùng ListView.builder để tối ưu
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        // Trả về Card cho mỗi buổi học
        return _buildSessionCard(session);
      },
    );
  }

  // Widget build một Card buổi học (theo layout ảnh mới)
  Widget _buildSessionCard(CourseSession session) {
    // Định dạng ngày
    final String formattedDate = DateFormat('dd/MM/yyyy').format(session.sessionDate);
    // Lấy tên môn học từ widget (vì tất cả đều giống nhau)
    final String subjectName = widget.courseName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề ngày
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
        // Thẻ Card
        Card(
          elevation: 0.5,
          margin: const EdgeInsets.only(bottom: 12.0),
          color: Colors.lightBlue[50], // Màu nền xanh nhạt
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
                        subjectName, // Tên môn học
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
                // Cột trạng thái (Số lượng, Status, Nút)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Số lượng: ${session.presentCount}/${session.totalStudents}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.statusText,
                      style: TextStyle(
                        color: session.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionDetailScreen(
                              sessionId: session.sessionId,

                              courseId: widget.courseId,
                              courseName: widget.courseName,
                              className: widget.className,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text('Chi tiết'),
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