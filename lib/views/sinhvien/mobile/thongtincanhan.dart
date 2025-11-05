import 'package:flutter/material.dart';

class ThongTinCaNhan extends StatelessWidget {
  const ThongTinCaNhan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarMenu(),
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text(
          'Trang chủ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
          ),
        ],
      ),
      body: const ProfileInfo(),
      bottomNavigationBar: const BottomIconBar(),
    );
  }
}

// -------------------- Sidebar --------------------
// -------------------- Sidebar --------------------
class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFF6F0F8), // màu nền nhẹ như ảnh bạn gửi
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              color: Colors.white.withOpacity(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 35, // nhỏ vừa phải
                    backgroundColor: Color(0xFFDCCAF6),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16),
                  ),
                  Text(
                    'abcde@gmail.com',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Các item menu
            const Divider(thickness: 0.5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // 👈 Dịch vào giữa
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text('Trang chủ'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Thông tin cá nhân'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.menu_book_outlined),
                    title: Text('Danh sách môn học'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month_outlined),
                    title: Text('Lịch sử điểm danh'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// -------------------- Thông tin cá nhân --------------------
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // 🔹 Avatar nhỏ lại
          const CircleAvatar(
            radius: 35, // Giảm từ 50 xuống 35
            backgroundImage: AssetImage('assets/avatar.jpg'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nguyễn Văn A',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'abcde@gmail.com',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 25),

          // Các dòng thông tin có gạch ngăn cách
          const Divider(thickness: 1.2),
          buildRowInfo('Tên', 'Nguyễn Văn A'),
          const Divider(thickness: 1.2),
          buildRowInfo('Email', 'abc@gmail.com'),
          const Divider(thickness: 1.2),
          buildRowInfo('Số điện thoại', '0123456789'),
          const Divider(thickness: 1.2),
          buildRowInfo('Địa chỉ', 'Hà Nội'),
          const Divider(thickness: 1.2),

          const SizedBox(height: 30),

          // Nút Sửa
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding:
              const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Sửa',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildRowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

// -------------------- Thanh 4 biểu tượng (chỉ hiển thị) --------------------
class BottomIconBar extends StatelessWidget {
  const BottomIconBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -1))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home, size: 28, color: Color(0xFF0D47A1)),
          Icon(Icons.person_outline, size: 26, color: Colors.grey),
          Icon(Icons.chat_bubble_outline, size: 26, color: Colors.grey),
          Icon(Icons.calendar_today, size: 26, color: Colors.grey),
        ],
      ),
    );
  }
}
