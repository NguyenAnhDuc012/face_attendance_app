// lib/screens/course_list_screen.dart
import 'package:face_attendance_app/lecturers/screens/course_detail_screen.dart';
import 'package:face_attendance_app/lecturers/screens/home.dart';
import 'package:flutter/material.dart';
import '../model/course_group.dart';
import '../services/course_service.dart';
import '../layouts/bottom_tab_nav.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late Future<List<StudyPeriodGroup>> _courseGroupFuture;
  int _selectedIndex = 3; // Giả sử tab 'Lịch' là index 3

  @override
  void initState() {
    super.initState();
    // Gọi API khi màn hình được tải
    _courseGroupFuture = CourseService.getCoursesByPeriod();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Thêm logic điều hướng nếu cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Nút quay lại
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Danh sách lớp học phần',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1.0,
        actions: [
          // Avatar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://placekitten.com/50/50'),
            ),
          ),
        ],
      ),
      // Body dùng FutureBuilder để tải dữ liệu
      body: FutureBuilder<List<StudyPeriodGroup>>(
        future: _courseGroupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có lớp học phần nào.'));
          }

          // Dữ liệu đã có
          final List<StudyPeriodGroup> groups = snapshot.data!;

          // Dùng ListView.builder cho các nhóm
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              // Trả về một widget cho mỗi nhóm
              return _buildStudyPeriodGroup(group);
            },
          );
        },
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Widget build một nhóm (Đợt học + danh sách các Card)
  Widget _buildStudyPeriodGroup(StudyPeriodGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề ngày tháng của đợt học
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Text(
            '${group.startDate} - ${group.endDate}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        // ListView.builder lồng bên trong cho các lớp học phần
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(), // Tắt cuộn
          shrinkWrap: true, // Co lại theo nội dung
          itemCount: group.courses.length,
          itemBuilder: (context, index) {
            final course = group.courses[index];
            return _buildCourseCard(course); // Build Card
          },
        ),
        const SizedBox(height: 16), // Khoảng cách giữa các nhóm
      ],
    );
  }

  // Widget build một Card lớp học phần
  Widget _buildCourseCard(SimpleCourse course) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12.0),
      color: Colors.lightBlue[50], // Màu nền xanh nhạt
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên môn học
            Text(
              course.subjectName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Tên lớp
            Text(
              course.className,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            // Nút "Chi tiết"
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến màn hình chi tiết
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(
                      courseId: course.id,
                      // Truyền tên để hiển thị ngay trên AppBar
                      courseName: course.subjectName,
                      className: course.className,
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
      ),
    );
  }
}