import 'package:flutter/material.dart';

class BottomTabNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // Hàm callback khi 1 tab được chọn

  const BottomTabNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Thêm đổ bóng nhẹ cho thanh điều hướng
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Icon khi được chọn
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_outlined),
            activeIcon: Icon(Icons.contact_page),
            label: 'Thẻ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Lịch',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: Colors.blue[700], // Màu icon được chọn
        unselectedItemColor: Colors.grey[600], // Màu icon chưa được chọn
        type: BottomNavigationBarType.fixed, // Luôn hiển thị các tab
        backgroundColor: Colors.white,
        elevation: 0, // Đã có box shadow bên ngoài
        // Ẩn các nhãn (label)
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}