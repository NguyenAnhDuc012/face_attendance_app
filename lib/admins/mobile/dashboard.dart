import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Nền màu xám nhạt như trong hình
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Inter',
      ),
      home: const StatisticsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  // Index của BottomNavBar, 2 tương ứng với icon "Description" (tài liệu/thống kê)
  int _selectedBottomNavIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------------------------
      // APP BAR
      // ------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.grey[50], // Nền xám nhạt
        foregroundColor: Colors.black, // Icon màu đen
        elevation: 0, // Không có đổ bóng
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Xử lý khi nhấn nút back
          },
        ),
        title: const Text(
          'Thống kê',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              // Giả sử bạn có ảnh avatar này trong assets
              backgroundImage: AssetImage('assets/images/meo.jpg'),
            ),
          ),
        ],
      ),

      // ------------------------------------
      // BODY CỦA ỨNG DỤNG
      // ------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tiêu đề chính ---
            const Text(
              'Tổng quan kỳ học',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // --- Thẻ Thống kê 1 ---
            _buildStatCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Số lượng giảng viên',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '50',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade600, // Màu xanh teal
                    ),
                  ),
                ],
              ),
            ),

            // --- Thẻ Thống kê 2 ---
            _buildStatCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Số lượng sinh viên',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1,232',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700, // Màu xanh tím
                    ),
                  ),
                ],
              ),
            ),

            // --- Thẻ Thống kê 3 ---
            _buildStatCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tỷ lệ vắng của sinh viên',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3.2%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600, // Màu đỏ
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tuần này: 3.2%',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tuần trước: 5.0%',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ------------------------------------
      // BOTTOM NAVIGATION BAR
      // ------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Nền trắng
        selectedItemColor: Colors.grey[850],
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Docs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }

  // --- Widget trợ giúp (helper widget) để tạo 1 thẻ thống kê ---
  Widget _buildStatCard({required Widget child}) {
    return SizedBox(
      width: double.infinity, // Cho thẻ rộng hết cỡ
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Bo góc
        ),
        elevation: 2.0, // Đổ bóng nhẹ
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20.0), // Khoảng cách giữa các thẻ
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding bên trong thẻ
          child: child,
        ),
      ),
    );
  }
}
