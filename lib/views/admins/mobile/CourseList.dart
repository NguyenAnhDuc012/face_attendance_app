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
      home: const ClassListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({super.key});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
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
            // --- Nút Thêm mới ---
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
                  'Thêm mới',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Tiêu đề danh sách ---
            const Text(
              'Danh sách lớp học phần:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // --- Danh sách Lớp học ---
            _buildClassCard(
              title: 'Phát triển ứng dụng cho các thiết bị di động 1231',
              className: '64KTPM1',
              color: buttonColor,
            ),
            // --- LỚP HỌC MỚI 1 ---
            _buildClassCard(
              title: 'Học tăng cường và ứng dụng',
              className: '64KHMT1',
              color: buttonColor, // Thay đổi màu cho khác biệt
            ),

            // --- LỚP HỌC MỚI 2 ---
            _buildClassCard(
              title: 'Tư tưởng Hồ Chí Minh',
              className: 'LLCT1',
              color: buttonColor, // Thay đổi màu cho khác biệt
            ),

            _buildClassCard(
              title: 'Tư tưởng Hồ Chí Minh',
              className: 'LLCT1',
              color: buttonColor, // Thay đổi màu cho khác biệt
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
  Widget _buildClassCard({
    required String title,
    required String className,
    required Color color,
  }) {
    // SỬA LỖI 1: Bọc Card bằng SizedBox để ép Card rộng hết cỡ
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1.5,
        margin: const EdgeInsets.only(bottom: 16.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
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

              // --- Nội dung (Tên, Lớp, Nút) ---
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0, // 8px (thanh màu) + 16px (padding)
                  right: 16.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // height: 48.0, // Đặt chiều cao đủ cho 2 dòng text
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      className,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),

                    // Dùng Wrap để các nút tự động xuống hàng nếu không đủ chỗ
                    Wrap(
                      spacing: 12.0, // Khoảng cách ngang giữa các nút
                      runSpacing: 8.0, // Khoảng cách dọc nếu nút xuống hàng
                      children: [
                        _buildSmallButton(text: 'Chi tiết', color: color),
                        _buildSmallButton(
                          text: 'Quản lý sinh viên',
                          color: color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget trợ giúp cho các nút nhỏ bên trong thẻ ---
  Widget _buildSmallButton({required String text, required Color color}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      child: Text(text),
    );
  }
}
