import 'package:flutter/material.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trang chủ',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(title: Text('Trang chủ')),
            ListTile(title: Text('Thông tin cá nhân')),
            ListTile(title: Text('Lịch học')),
            ListTile(title: Text('Cài đặt')),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Trang chủ",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Chào Nguyễn Văn A!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 4),
                    Text("MSSV: 2251177753"),
                    Text("Lớp: 64KTPM"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Lịch học hôm nay",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // --- Môn 1 ---
            _buildCourseCard(
              title: "Lập trình ứng dụng cho các thiết bị di động",
              code: "64KTPM.NB",
              status: "có mặt",
              time: "7:00 - 7:50",
              room: "Phòng 329 - A2",
              backgroundColor: Colors.green.shade50,
              statusColor: Colors.green.shade700,
              actionText: "Điểm danh kết thúc",
              actionColor: Colors.green.shade700,
              hasButton: false, // ❌ Không có button
            ),
            const SizedBox(height: 12),

            // --- Môn 2 ---
            _buildCourseCard(
              title: "Học tăng cường và ứng dụng",
              code: "64KTPM 1",
              status: "?",
              time: "7:55 - 8:50",
              room: "Phòng 329 - A2",
              backgroundColor: Colors.blue.shade50,
              actionText: "Điểm danh",
              actionColor: Colors.blue,
              hasButton: true, // ✅ Có button
            ),
            const SizedBox(height: 12),

            // --- Môn 3 ---
            _buildCourseCard(
              title: "Tư tưởng Hồ Chí Minh",
              code: "64KTPM 2",
              status: "?",
              time: "8:55 - 10:50",
              room: "Phòng 329 - A2",
              backgroundColor: Colors.blue.shade50,
              actionText: "Lớp chưa mở",
              actionColor: Colors.grey,
              hasButton: true, // ✅ Có button
            ),
          ],
        ),
      ),
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

  Widget _buildCourseCard({
    required String title,
    required String code,
    required String status,
    required String time,
    required String room,
    required Color backgroundColor,
    required String actionText,
    required Color actionColor,
    required bool hasButton,
    Color? statusColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, height: 1.2)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: const TextStyle(fontSize: 13)),
              Text("Trạng thái: $status",
                  style: TextStyle(
                      color: statusColor ?? Colors.black54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$time\n$room", style: const TextStyle(fontSize: 13)),
              if (hasButton)
                Container(
                  decoration: BoxDecoration(
                    color: actionColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    actionText,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                )
              else
                Text(
                  actionText,
                  style: TextStyle(
                      color: actionColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
