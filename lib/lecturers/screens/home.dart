// lib/screens/HomeScreen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Đảm bảo bạn đã import đúng đường dẫn
import '../layouts/bottom_tab_nav.dart';
import '../layouts/drawer.dart';
import '../layouts/header.dart';

// ----- HomeScreen (Giữ nguyên) -----
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến state để theo dõi tab đang được chọn
  int _selectedIndex = 0;

  // Hàm cập nhật state khi người dùng bấm tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold là cấu trúc cơ bản của một màn hình
    return Scaffold(
      appBar: const CustomHeader(), // Sử dụng header tùy chỉnh
      drawer: const CustomDrawer(), // Sử dụng drawer tùy chỉnh
      body: const HomeBody(), // Nội dung chính của trang
      bottomNavigationBar: BottomTabNav(
        currentIndex: _selectedIndex, // Truyền state hiện tại
        onTap: _onItemTapped, // Truyền hàm callback
      ),
    );
  }
}

// ----- HomeBody (Giữ nguyên) -----
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    // ListView để nội dung có thể cuộn
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Card chào mừng (Đã được cập nhật bên dưới)
        const WelcomeCard(),
        const SizedBox(height: 24),
        // Tiêu đề "Lịch dạy hôm nay"
        Text(
          'Lịch dạy hôm nay',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Các card lịch dạy (có thể tái sử dụng)
        const ScheduleCard(
          subject: 'Lập trình ứng dụng cho các thiết bị di động',
          time: '7:00 - 7:50',
          room: 'Phòng 329 - A2',
          classCode: '64KTPM.NB',
          count: '50/50',
          status: 'Điểm danh kết thúc',
          statusColor: Colors.green, // Màu cho trạng thái
        ),
        const SizedBox(height: 16),
        const ScheduleCard(
          subject: 'Học tăng cường và ứng dụng',
          time: '7:55 - 8:50',
          room: 'Phòng 329 - A2',
          classCode: '64KTPM 1',
          count: '7/40',
          status: 'Chưa diễn ra',
          statusColor: Colors.orange, // Màu cho trạng thái
        ),
        const ScheduleCard(
          subject: 'Lập trình ứng dụng cho các thiết bị di động',
          time: '7:00 - 7:50',
          room: 'Phòng 329 - A2',
          classCode: '64KTPM.NB',
          count: '50/50',
          status: 'Điểm danh kết thúc',
          statusColor: Colors.green, // Màu cho trạng thái
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ----- WelcomeCard (ĐÃ CHUYỂN THÀNH STATEFUL) -----
class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});

  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  String _lecturerName = 'Đang tải...'; // Giá trị mặc định

  @override
  void initState() {
    super.initState();
    _loadLecturerInfo(); // Gọi hàm load thông tin
  }

  // Hàm load thông tin từ SharedPreferences
  Future<void> _loadLecturerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('user_full_name');

    if (mounted) {
      setState(() {
        // Nếu không tìm thấy tên, hiển thị 'Giảng viên'
        _lecturerName = fullName ?? 'Giảng viên';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              // Thay thế bằng ảnh của bạn
              backgroundImage: NetworkImage('https://placekitten.com/100/100'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HIỂN THỊ TÊN TỪ STATE
                Text(
                  'Chào $_lecturerName!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Khoa: Công nghệ thông tin', // (Phần này bạn có thể cập nhật sau)
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

// ----- ScheduleCard (Giữ nguyên) -----
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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