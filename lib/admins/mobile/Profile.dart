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
        scaffoldBackgroundColor: Colors.white, // Nền trắng
        fontFamily: 'Inter',
      ),
      home: const ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Index của BottomNavBar, 1 tương ứng với icon "Person"
  int _selectedBottomNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    // Màu xanh/tím cho các nút
    final buttonColor = Colors.indigo.shade700;

    return Scaffold(
      // ------------------------------------
      // APP BAR
      // ------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Xử lý khi nhấn nút back
          },
        ),
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              // Giả sử bạn có ảnh avatar2.png cho user này
              backgroundImage: AssetImage('assets/images/meo.jpg'),
            ),
          ),
        ],
      ),

      // ------------------------------------
      // BODY CỦA ỨNG DỤNG
      // ------------------------------------
      body: SingleChildScrollView(
        // Dùng SingleChildScrollView để tránh lỗi overflow khi mở bàn phím
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            // --- Khối Avatar và Tên (Căn giữa) ---
            SizedBox(
              width: double.infinity, // Đảm bảo Column con căn giữa theo chiều ngang
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Giả sử bạn có ảnh avatar1.png cho avatar chính
                    backgroundImage: AssetImage('assets/images/meo.jpg'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'abcde@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), // Khoảng cách lớn

            // --- Khối Thông tin chi tiết ---
            _buildInfoRow('Tên', 'Nguyễn Văn A'),
            const Divider(height: 32), // Divider với khoảng cách trên dưới
            _buildInfoRow('Email', 'abc@gmail.com'),
            const Divider(height: 32),
            _buildInfoRow('Số điện thoại', '0123456789'),
            const Divider(height: 32),
            _buildInfoRow('Địa chỉ', 'Hà Nội'),

            const SizedBox(height: 48), // Khoảng cách lớn trước nút

            // --- Khối Nút (Căn giữa) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Sửa
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child: const Text('Sửa', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 16),

                // Nút Đổi mật khẩu
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                  child:
                  const Text('Đổi mật khẩu', style: TextStyle(fontSize: 16)),
                ),
              ],
            )
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

  // --- Widget trợ giúp (helper widget) để tạo 1 hàng thông tin ---
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nhãn (Label)
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        // Giá trị (Value)
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}