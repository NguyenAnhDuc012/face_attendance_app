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
      home: const SubjectListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  // Index của BottomNavBar, 2 tương ứng với icon "Description" (Tài liệu)
  int _selectedBottomNavIndex = 2;

  @override
  Widget build(BuildContext context) {
    final buttonColor = Colors.indigo.shade700; // Màu xanh tím

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
          'Danh sách môn học',
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
            // --- Nút Thêm môn học ---
            SizedBox(
              width: double.infinity, // Cho nút rộng hết cỡ
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Thêm môn học mới',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Tiêu đề danh sách ---
            const Text(
              'Môn học đã có:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // --- Danh sách môn học ---
            _buildSubjectCard(
              title: 'Phát triển ứng dụng cho các thiết bị di động',
              color: buttonColor,
            ),
            _buildSubjectCard(
              title: 'Học tăng cường và ứng dụng',
              color: buttonColor,
            ),
            _buildSubjectCard(
              title: 'Tư tưởng Hồ Chí Minh',
              color: buttonColor,
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

  // --- Widget trợ giúp (helper widget) để tạo 1 thẻ môn học ---
  Widget _buildSubjectCard({required String title, required Color color}) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      // Dùng ClipRRect để bo góc cho cả các widget con bên trong
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            // --- Thanh màu bên trái ---
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 8.0, color: color),
            ),

            // --- Tên môn học ---
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0, // 8px (thanh màu) + 16px (padding)
                right: 16.0,
                top: 20.0,
                bottom: 20.0,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
