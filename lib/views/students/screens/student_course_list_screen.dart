import 'package:face_attendance_app/students/screens/student_course_detail_screen.dart';
import 'package:face_attendance_app/students/screens/student_home_screen.dart';
import 'package:flutter/material.dart';
import '../model/student_course_group.dart';
import '../services/student_course_service.dart';
import '../layouts/bottom_tab_nav.dart';

class StudentCourseListScreen extends StatefulWidget {
  const StudentCourseListScreen({super.key});

  @override
  State<StudentCourseListScreen> createState() =>
      _StudentCourseListScreenState();
}

class _StudentCourseListScreenState extends State<StudentCourseListScreen> {
  // --- (3) THAY ĐỔI MODEL VÀ SERVICE ---
  late Future<List<StudentStudyPeriodGroup>> _courseGroupFuture;
  int _selectedIndex = 3; // Giả sử tab 'Lịch' là index 3

  @override
  void initState() {
    super.initState();
    // Gọi service của Student
    _courseGroupFuture = StudentCourseService.getMyCoursesByPeriod();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
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
              backgroundImage: NetworkImage('https://picsum.photos/50/50'),            ),
          ),
        ],
      ),

      body: FutureBuilder<List<StudentStudyPeriodGroup>>( // Dùng model của Student
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

          final List<StudentStudyPeriodGroup> groups = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
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

  // Widget build một nhóm (Đợt học)
  Widget _buildStudyPeriodGroup(StudentStudyPeriodGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Text(
            '${group.startDate} - ${group.endDate}', // Ngày tháng
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: group.courses.length,
          itemBuilder: (context, index) {
            final course = group.courses[index];
            return _buildCourseCard(course); // Build Card
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Widget build một Card lớp học phần
  // --- (5) THAY ĐỔI CARD ĐỂ HIỂN THỊ TÊN GV ---
  Widget _buildCourseCard(StudentSimpleCourse course) {
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
            // Tên Giảng viên (thay vì tên lớp)
            Text(
              'GV: ${course.lecturerName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            // Nút "Chi tiết"
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến màn hình chi tiết mới
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentCourseDetailScreen(
                      courseId: course.id,
                      // Truyền tên để hiển thị
                      courseName: course.subjectName,
                      lecturerName: course.lecturerName,
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