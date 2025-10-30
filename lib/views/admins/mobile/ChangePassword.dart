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
      home: const ChangePasswordScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Index của BottomNavBar, 1 tương ứng với icon "Person"
  int _selectedBottomNavIndex = 1;

  // Controller để hiển thị text giả lập cho "Mật khẩu cũ"
  final _oldPasswordController = TextEditingController(text: '**************');

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
          'Đổi mật khẩu',
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
        // Dùng SingleChildScrollView để form có thể cuộn
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Mật khẩu cũ',
              hint: '', // Không cần hint vì đã có text
              isPassword: true,
              controller:
                  _oldPasswordController, // Dùng controller để hiển thị text
            ),
            _buildTextField(
              label: 'Mật khẩu mới',
              hint: 'Nhập mật khẩu mới tại đây',
              isPassword: true,
            ),
            _buildTextField(
              label: 'Xác nhận mật khẩu mới',
              hint: 'Xác nhận mật khẩu mới tại đây',
              isPassword: true,
            ),
            const SizedBox(height: 32),

            // --- Nút Lưu ---
            SizedBox(
              width: double.infinity, // Cho nút rộng hết cỡ
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý logic lưu
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700, // Màu xanh tím
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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

  // --- Widget trợ giúp (helper widget) để tạo 1 khối (Nhãn + Ô nhập liệu) ---
  Widget _buildTextField({
    required String label,
    required String hint,
    bool isPassword = false,
    TextEditingController? controller, // Thêm controller
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nhãn (Label)
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Ô nhập liệu (TextFormField)
          TextFormField(
            controller: controller, // Gán controller
            obscureText: isPassword, // Ẩn text nếu là mật khẩu
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              // Viền bo tròn
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              // Viền khi được focus (nhấn vào)
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.indigo.shade700,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
