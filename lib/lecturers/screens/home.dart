import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/today_schedule.dart';
import '../services/schedule_service.dart';

import '../layouts/bottom_tab_nav.dart';
import '../layouts/drawer.dart';
import '../layouts/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
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
  // Biến state để lưu trữ kết quả API
  late Future<List<TodaySchedule>> _todayScheduleFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API khi widget được tải
    _todayScheduleFuture = ScheduleService.getTodaySchedule();
  }

  // Hàm helper để đổi status text
  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Đang diễn ra';
      case 'closed':
        return 'Điểm danh kết thúc';
      case 'pending':
      default:
        return 'Chưa diễn ra';
    }
  }

  // Hàm helper để lấy màu status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.blue; // Đang diễn ra
      case 'closed':
        return Colors.green; // Kết thúc
      case 'pending':
      default:
        return Colors.orange; // Chưa diễn ra
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const WelcomeCard(), // WelcomeCard đã có logic tự load tên
        const SizedBox(height: 24),
        Text(
          'Lịch dạy hôm nay',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // ===== SỬ DỤNG FutureBuilder ĐỂ LOAD DATA =====
        FutureBuilder<List<TodaySchedule>>(
          future: _todayScheduleFuture,
          builder: (context, snapshot) {
            // Trường hợp 1: Đang tải dữ liệu
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Trường hợp 2: Bị lỗi
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi tải lịch học: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // Trường hợp 3: Không có dữ liệu (hoặc API trả về mảng rỗng)
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Hôm nay không có lịch dạy.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // Trường hợp 4: Có dữ liệu
            final schedules = snapshot.data!;
            return ListView.builder(
              // Quan trọng: Tắt cuộn của ListView con
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true, // Để nó nằm trong ListView cha
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];

                // Trả về ScheduleCard với dữ liệu thật
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ScheduleCard(
                    subject: schedule.subjectName,
                    time: '${schedule.startTime} - ${schedule.endTime}',
                    room: schedule.roomName,
                    classCode: schedule.className,
                    count: '${schedule.presentCount}/${schedule.totalStudents}',
                    status: _getStatusText(schedule.status),
                    statusColor: _getStatusColor(schedule.status),
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

// ----- WelcomeCard (Giữ nguyên như code của bạn) -----
class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});
  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  String _lecturerName = 'Đang tải...';
  @override
  void initState() {
    super.initState();
    _loadLecturerInfo();
  }
  Future<void> _loadLecturerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('user_full_name');
    if (mounted) {
      setState(() {
        _lecturerName = fullName ?? 'Giảng viên';
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
              backgroundImage: NetworkImage('https://placekitten.com/100/100'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chào $_lecturerName!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Khoa: Công nghệ thông tin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
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

// ----- ScheduleCard (Giữ nguyên như code của bạn) -----
class ScheduleCard extends StatelessWidget {
  final String subject;
  final String time;
  final String room;
  final String classCode;
  final String count;
  final String status;
  final Color statusColor;

  const ScheduleCard({
    super.key,
    required this.subject,
    required this.time,
    required this.room,
    required this.classCode,
    required this.count,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
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
                      classCode,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Số lượng: $count',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
    );
  }
}