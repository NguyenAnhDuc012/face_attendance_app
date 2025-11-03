import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      // --- AppBar ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Lập trình Mobile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
        ],
      ),

      // --- Nội dung chính ---
      body: Column(
        children: [
          // Thanh điều hướng “Sắp tới / Đã qua”
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Sắp tới",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  children: const [
                    Text(
                      "Đã qua",
                      style: TextStyle(
                        color: Color(0xFF205BF3),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      child: Divider(
                        color: Color(0xFF205BF3),
                        thickness: 2,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Danh sách buổi học (ĐÃ QUA)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  classCard(
                    "Lập trình ứng dụng cho các thiết bị di động",
                    "64KTPM.NB",
                    "7:00 - 7:50",
                    "Phòng 329 - A2",
                    "Số lượng: 9/50",
                  ),
                  classCard(
                    "Học tăng cường và ứng dụng",
                    "64KTPM 1",
                    "7:55 - 8:50",
                    "Phòng 329 - A2",
                    "Số lượng: 7/40",
                  ),
                  classCard(
                    "Tư tưởng Hồ Chí Minh",
                    "64KTPM 2",
                    "8:55 - 10:50",
                    "Phòng 329 - A2",
                    "Số lượng: 7/38",
                  ),
                  classCard(
                    "Học tăng cường và ứng dụng",
                    "64KTPM 1",
                    "7:55 - 8:50",
                    "Phòng 329 - A2",
                    "Số lượng: 7/40",
                  ),
                  classCard(
                    "Tư tưởng Hồ Chí Minh",
                    "64KTPM 2",
                    "8:55 - 10:50",
                    "Phòng 329 - A2",
                    "Số lượng: 7/38",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- Thanh navigation dưới ---
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

  // --- Hàm tạo khung buổi học ---
  static Widget classCard(
      String title, String code, String time, String room, String count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: const TextStyle(color: Colors.black54)),
              Text(count, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Colors.black54)),
          Text(room, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Điểm danh kết thúc",
                  style: TextStyle(color: Colors.black54)),
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF205BF3),
                  disabledBackgroundColor: const Color(0xFF205BF3),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Chi tiết",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
