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
      home: const StudentManagementScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  // Index của BottomNavBar, 2 tương ứng với icon "Description" (Tài liệu)
  int _selectedBottomNavIndex = 2;

  // Dữ liệu giả lập
  final List<Map<String, String>> students = List.generate(
    4,
    (index) => {
      'name': 'Nguyễn Văn C',
      'email': 'abcde@gmail.com',
      'avatarPath': 'assets/images/meo.jpg',
    },
  );

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
          'Lớp học phần',
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
            // --- Nút Thêm sinh viên ---
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
                  'Thêm sinh viên',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Tiêu đề danh sách ---
            const Text(
              'Danh sách sinh viên (40)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // --- Danh sách sinh viên (ListView) ---
            ListView.builder(
              itemCount: students.length,
              shrinkWrap: true, // Quan trọng khi lồng ListView trong Column
              physics:
                  const NeverScrollableScrollPhysics(), // Tắt cuộn của ListView
              itemBuilder: (context, index) {
                final student = students[index];
                return _buildStudentCard(
                  name: student['name']!,
                  email: student['email']!,
                  avatarPath: student['avatarPath']!,
                  onDelete: () {
                    // Xử lý logic xóa
                  },
                );
              },
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

  // --- Widget trợ giúp (helper widget) để tạo 1 thẻ sinh viên ---
  Widget _buildStudentCard({
    required String name,
    required String email,
    required String avatarPath,
    required VoidCallback onDelete,
  }) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(radius: 28, backgroundImage: AssetImage(avatarPath)),
            const SizedBox(width: 16),

            // Cột Tên và Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Icon Xóa (Delete)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade400, size: 28),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
