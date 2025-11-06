import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_today_schedule.dart';
import '../services/student_schedule_service.dart';

import '../layouts/bottom_tab_nav.dart';
import '../layouts/drawer.dart';
import '../layouts/student_header.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});
  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StudentHeader(),
      drawer: const CustomDrawer(),
      body: const HomeBody(),
      bottomNavigationBar: BottomTabNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late Future<List<StudentTodaySchedule>> _todayScheduleFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API của Student
    _todayScheduleFuture = StudentScheduleService.getTodaySchedule();
  }

  // Hàm helper (cập nhật cho Student)
  String _getMyStatusText(String status) {
    switch (status) {
      case 'present':
        return 'Bạn đã có mặt';
      case 'late':
        return 'Bạn đã điểm danh (Trễ)';
      case 'absent':
        return 'Bạn vắng mặt';
      case 'excused':
        return 'Bạn đã xin phép';
      default:
        return 'Chưa điểm danh';
    }
  }

  // Hàm helper (cập nhật cho Student)
  Color _getMyStatusColor(String status) {
    switch (status) {
      case 'present':
      case 'late':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'excused':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const WelcomeCard(),
        const SizedBox(height: 24),
        Text(
          'Lịch học hôm nay',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<StudentTodaySchedule>>(
          future: _todayScheduleFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi tải lịch học: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Hôm nay không có lịch học.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // Có dữ liệu
            final schedules = snapshot.data!;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: StudentScheduleCard(
                    subject: schedule.subjectName,
                    time: '${schedule.startTime} - ${schedule.endTime}',
                    room: schedule.roomName,
                    lecturerName: schedule.lecturerName,
                    myStatus: _getMyStatusText(schedule.myAttendanceStatus),
                    myStatusColor: _getMyStatusColor(
                      schedule.myAttendanceStatus,
                    ),
                    sessionStatus: schedule.sessionStatus,
                    onTap: () {
                      // TODO: Điều hướng đến màn hình điểm danh của SV
                      print("Navigating to session ${schedule.sessionId}");
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});
  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  String _studentName = 'Đang tải...';
  String _className = '...';

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    // LẤY KEY CỦA SINH VIÊN
    final fullName = prefs.getString('student_full_name');
    final className = prefs.getString('student_class_name');

    if (mounted) {
      setState(() {
        _studentName = fullName ?? 'Sinh viên';
        _className = className ?? 'Chưa có lớp';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://picsum.photos/100/100'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chào $_studentName!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lớp: $_className',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StudentScheduleCard extends StatelessWidget {
  final String subject;
  final String time;
  final String room;
  final String lecturerName;
  final String myStatus;
  final Color myStatusColor;
  final String sessionStatus; // 'pending', 'active', 'closed'
  final VoidCallback onTap;

  const StudentScheduleCard({
    super.key,
    required this.subject,
    required this.time,
    required this.room,
    required this.lecturerName,
    required this.myStatus,
    required this.myStatusColor,
    required this.sessionStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Nút "Điểm danh" chỉ bật khi buổi học 'active'
    final bool canAttend = (sessionStatus == 'active');

    return Card(
      elevation: 1.0,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(time, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            const SizedBox(height: 4),
            Text(room, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GV: $lecturerName', // Hiển thị tên Giảng viên
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Trạng thái của bạn:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      myStatus, // Hiển thị trạng thái của SV
                      style: TextStyle(
                        color: myStatusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: canAttend ? onTap : null, // Chỉ bật khi 'active'
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    // Làm mờ nút nếu không thể điểm danh
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  // Đổi chữ trên nút
                  child: Text(
                    sessionStatus == 'closed' ? 'Đã kết thúc' : 'Điểm danh',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
