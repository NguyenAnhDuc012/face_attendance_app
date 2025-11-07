import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart';
import '../layouts/drawer.dart';
import '../layouts/header.dart';
//Trang chủ 
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
      body: const HomeBody(), // Giữ nguyên layout cũ
      bottomNavigationBar: BottomTabNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ===================== HOME BODY =====================
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake data mẫu
    final fakeSchedules = [
      {
        'subject': 'Lập trình Flutter',
        'time': '07:30 - 09:15',
        'room': 'A202',
        'classCode': 'CTK45A',
        'count': '25/30',
        'status': 'Đang diễn ra',
        'statusColor': Colors.blue,
      },
      {
        'subject': 'Cấu trúc dữ liệu & Giải thuật',
        'time': '09:30 - 11:15',
        'room': 'A203',
        'classCode': 'CTK45B',
        'count': '28/28',
        'status': 'Chưa diễn ra',
        'statusColor': Colors.orange,
      },
      {
        'subject': 'Cơ sở dữ liệu',
        'time': '13:00 - 14:45',
        'room': 'B101',
        'classCode': 'CTK45C',
        'count': '26/27',
        'status': 'Điểm danh kết thúc',
        'statusColor': Colors.green,
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const WelcomeCard(),
        const SizedBox(height: 24),
        Text(
          'Lịch dạy hôm nay',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Duyệt qua danh sách giả
        for (final s in fakeSchedules)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ScheduleCard(
              subject: s['subject'] as String,
              time: s['time'] as String,
              room: s['room'] as String,
              classCode: s['classCode'] as String,
              count: s['count'] as String,
              status: s['status'] as String,
              statusColor: s['statusColor'] as Color,
            ),
          ),
      ],
    );
  }
}

// ===================== WELCOME CARD =====================
class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

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
                  'Chào Giảng viên Nguyễn Văn A!',
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

// ===================== SCHEDULE CARD =====================
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
                  onPressed: () {
                    // Tĩnh -> chỉ show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mở chi tiết: $subject')),
                    );
                  },
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

// ===================== MAIN CHẠY ĐỘC LẬP =====================
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}
