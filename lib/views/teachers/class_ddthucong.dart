import 'package:flutter/material.dart';

void main() {
  runApp(const ManualAttendanceUI());
}

class ManualAttendanceUI extends StatelessWidget {
  const ManualAttendanceUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManualAttendancePage(),
    );
  }
}

class ManualAttendancePage extends StatefulWidget {
  const ManualAttendancePage({super.key});

  @override
  State<ManualAttendancePage> createState() => _ManualAttendancePageState();
}

class _ManualAttendancePageState extends State<ManualAttendancePage> {
  String? selectedStatus = "Có mặt";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 28),
          onPressed: () {},
        ),
        title: const Text(
          "Điểm danh",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Thông tin sinh viên ---
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Nguyễn Anh A",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Lập trình Mobile",
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Ngày: 20/10/2025 | Thời gian kết thúc: 10:30",
                      style: TextStyle(fontSize: 15, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Chọn trạng thái điểm danh cho buổi học:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Buổi 10:  Tuần 2(Thứ 2, Ngày 10/12/2025)",
              style: TextStyle(fontSize: 17, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // --- Các lựa chọn trạng thái ---
            _buildOptionTile(
              title: "Có mặt",
              subtitle: "Bạn có mặt tại lớp",
              color: const Color(0xFFDFFFE0),
              icon: Icons.check_circle,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              title: "Muộn",
              subtitle: "Bạn có mặt tại lớp",
              color: const Color(0xFFFFF4CC),
              icon: Icons.access_time_filled,
              iconColor: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              title: "Vắng",
              subtitle: "Bạn có mặt tại lớp",
              color: const Color(0xFFFFE0E0),
              icon: Icons.cancel_rounded,
              iconColor: Colors.red,
            ),

            const Spacer(),

            // --- Nút xác nhận ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF205BF3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Xác nhận",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),

      // --- Thanh điều hướng dưới ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Lịch học"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: "Lớp học"),
        ],
      ),
    );
  }

  // --- Widget hiển thị từng lựa chọn ---
  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = selectedStatus == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = title;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
