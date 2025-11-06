// lib/layouts/CustomDrawer.dart
import 'package:face_attendance_app/lecturers/screens/Login.dart';
import 'package:face_attendance_app/lecturers/screens/course_list_screen.dart';
import 'package:face_attendance_app/lecturers/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Đảm bảo đường dẫn import này là chính xác
import '../services/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // 1. TẠO HÀM XỬ LÝ ĐĂNG XUẤT
  // Hàm này nhận BuildContext để có thể điều hướng
  Future<void> _logout(BuildContext context) async {
    // 1.1. Hiển thị hộp thoại xác nhận
    final bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Trả về false
              },
            ),
            TextButton(
              child: const Text('Đồng ý', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Trả về true
              },
            ),
          ],
        );
      },
    );

    // 1.2. Nếu người dùng không đồng ý, dừng lại
    if (confirm != true) {
      return;
    }

    // 1.3. (Tùy chọn) Gọi API logout
    AuthService.logout();

    // 1.4. Xóa dữ liệu SharedPreferences (quan trọng nhất)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa tất cả dữ liệu đã lưu

    // 1.5. Quay về màn hình Login và xóa tất cả màn hình cũ
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false, // Xóa tất cả các route
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Phần header của Drawer
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Các mục trong menu
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Các lớp học phần'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CourseListScreen()),
              );
            },
          ),

          const Divider(),

          // 2. CẬP NHẬT NÚT ĐĂNG XUẤT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red), // Thêm màu
            title: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red), // Thêm màu
            ),
            onTap: () {
              // 3. GỌI HÀM _logout KHI NHẤN
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}