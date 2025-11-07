import 'package:flutter/material.dart';
import '../layouts/bottom_tab_nav.dart'; // vẫn giữ layout gốc
//Điểm danh bằng QR
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FakeQrCodeScreen(),
  ));
}

class FakeQrCodeScreen extends StatelessWidget {
  const FakeQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {},
        ),
        title: const Text(
          'Điểm danh QR',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Thẻ thông tin buổi học ---
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Lớp học hiện tại',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'Lập trình Flutter - CT101',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('08/11/2025',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    SizedBox(width: 24),
                    Icon(Icons.access_time_outlined,
                        size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('08:00 - 09:30',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Phòng B203',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // --- "QR Code" giả ---
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.qr_code, size: 100, color: Colors.black54),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- Đồng hồ đếm ngược (giả) ---
          Center(
            child: Column(
              children: const [
                Text(
                  'Thời gian còn lại:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  '14:59',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // --- Nút kết thúc ---
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'Kết thúc điểm danh',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: 3,
        onTap: (index) {},
      ),
    );
  }
}
