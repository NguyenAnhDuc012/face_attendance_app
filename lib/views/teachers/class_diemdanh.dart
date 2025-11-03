import 'package:flutter/material.dart';

void main() {
  runApp(const DiemDanhApp());
}

class DiemDanhApp extends StatelessWidget {
  const DiemDanhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Điểm danh',
      home: const DiemDanhScreen(),
    );
  }
}

class DiemDanhScreen extends StatelessWidget {
  const DiemDanhScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF205BF3);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Điểm danh',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Thông tin lớp học ---
            Container(
              width: double.infinity, // chiếm toàn màn hình
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lớp học hiện tại", style: TextStyle(color: blueColor, fontSize: 16)),
                  SizedBox(height: 6),
                  Text(
                    "Lập trình Mobile",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(height: 4),
                  Text("Thứ bảy, 07:00 - 09:30", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Nút bắt đầu điểm danh ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Bắt đầu điểm danh",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // chữ trắng
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- Thông báo ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Buổi điểm danh đã kết thúc. 20/45 sinh viên có mặt.",
                textAlign: TextAlign.center,
                style: TextStyle(color: blueColor, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // --- Thống kê ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBox("45", "Tổng SV", blueColor),
                _buildStatBox("0", "Đã có mặt", Colors.green),
                _buildStatBox("45", "Vắng mặt", Colors.red),
              ],
            ),
            const SizedBox(height: 28),

            // --- Hành động khác ---
            const Text(
              "Hành động khác",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            _buildActionRow("Xem chi tiết", "Xem ngay"),
            const Divider(),
            _buildActionRow("Điểm danh Thủ công", "Thực hiện"),
          ],
        ),
      ),

      // --- Thanh navigation dưới cùng ---
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Lớp học"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Lịch học"),
        ],
      ),

    );
  }

  Widget _buildStatBox(String value, String label, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildActionRow(String title, String actionText) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Text(
        actionText,
        style: const TextStyle(color: Color(0xFF205BF3), fontSize: 16),
      ),
    );
  }
}
