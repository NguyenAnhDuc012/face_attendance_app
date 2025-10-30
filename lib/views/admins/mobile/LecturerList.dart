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
        scaffoldBackgroundColor: Colors.grey[50], // Nền hơi xám
        fontFamily:
            'Inter', // Sử dụng font chữ đẹp (thêm vào pubspec.yaml nếu muốn)
      ),
      home: const LecturerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LecturerScreen extends StatefulWidget {
  const LecturerScreen({super.key});

  @override
  State<LecturerScreen> createState() => _LecturerScreenState();
}

class _LecturerScreenState extends State<LecturerScreen> {
  // Index để theo dõi mục nào đang được chọn trên BottomNavBar
  int _selectedBottomNavIndex = 0;

  // Index của giảng viên đang được chọn trong danh sách
  int _selectedLecturerIndex = 2; // Hardcode mục thứ 3 được chọn

  // Dữ liệu giả lập
  final List<Map<String, String>> lecturers = [
    {
      'name': 'Nguyễn Văn A',
      'email': 'nva@gmail.com',
      'avatarPath': 'assets/images/meo.jpg', // <-- Ảnh 1
    },
    {
      'name': 'Trần Thị B',
      'email': 'ttb@gmail.com',
      'avatarPath': 'assets/images/meo.jpg', // <-- Ảnh 2
    },
    {
      'name': 'Lê Văn C',
      'email': 'lvc@gmail.com',
      'avatarPath': 'assets/images/meo.jpg', // <-- Ảnh 3
    },
    {
      'name': 'Phạm Thị D',
      'email': 'ptd@gmail.com',
      'avatarPath': 'assets/images/meo.jpg', // <-- Có thể dùng lại ảnh
    },
    {
      'name': 'Nguyễn Văn C', // Mục này sẽ được chọn
      'email': 'abcde@gmail.com',
      'avatarPath': 'assets/images/meo.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------------------------
      // APP BAR
      // ------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Màu cho icon và text
        elevation: 1.0, // Đổ bóng nhẹ
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Xử lý khi nhấn nút back
          },
        ),
        title: const Text(
          'Giảng viên',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/meo.jpg'),
            ),
          ),
        ],
      ),

      // ------------------------------------
      // BODY CỦA ỨNG DỤNG
      // ------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Hàng "Danh sách giảng viên" và nút "Thêm mới" ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách giảng viên',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade700, // Màu xanh đậm
                    foregroundColor: Colors.white, // Màu chữ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Thêm mới'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Danh sách giảng viên (ListView) ---
            Expanded(
              child: ListView.builder(
                itemCount: lecturers.length,
                // ...
                itemBuilder: (context, index) {
                  final lecturer = lecturers[index];
                  final bool isSelected = (index == _selectedLecturerIndex);

                  return LecturerCard(
                    name: lecturer['name']!,
                    email: lecturer['email']!,
                    avatarPath: lecturer['avatarPath']!, // <-- Sửa dòng này
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedLecturerIndex = index;
                      });
                    },
                  );
                },
                // ...
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
        type: BottomNavigationBarType.fixed, // Luôn hiển thị 4 mục
        selectedItemColor: Colors.grey[850], // Màu mục được chọn
        unselectedItemColor: Colors.grey[400], // Màu mục không được chọn
        showSelectedLabels: false, // Ẩn nhãn
        showUnselectedLabels: false, // Ẩn nhãn
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Icon khi được chọn
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
}

// ------------------------------------
// WIDGET TÁCH BIỆT CHO MỖI THẺ GIẢNG VIÊN
// ------------------------------------
class LecturerCard extends StatelessWidget {
  final String name;
  final String email;
  final String avatarPath;
  final bool isSelected;
  final VoidCallback onTap;

  const LecturerCard({
    super.key,
    required this.name,
    required this.email,
    required this.avatarPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1.5,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          // Thêm viền xanh nếu isSelected là true
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/images/meo.jpg'),
              ),
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
              // Icon mũi tên
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
