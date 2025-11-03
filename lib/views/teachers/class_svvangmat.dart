import 'package:flutter/material.dart';

void main() {
  runApp(const AttendanceAbsentUI());
}

class AttendanceAbsentUI extends StatelessWidget {
  const AttendanceAbsentUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AbsentPage(),
    );
  }
}

class AbsentPage extends StatelessWidget {
  const AbsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> students = List.generate(
      3,
          (index) => {
        "name": "Nguyễn Anh A",
        "id": "2251175761",
        "status": "Vắng mặt",
        "note": "(chưa điểm danh)",
      },
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
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
      drawer: const Drawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Danh sách điểm danh ---
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Card(
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
                      "Danh sách điểm danh",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
          ),

          // --- Tab mô phỏng ---
          Container(
            color: const Color(0xFFF3F3F3),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text(
                      "Có mặt (20)",
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.blue, width: 3),
                      ),
                    ),
                    child: const Text(
                      "Vắng mặt (20)",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Danh sách vắng mặt ---
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final s = students[index];
                return _buildAbsentCard(s);
              },
            ),
          ),
        ],
      ),

      // --- Bottom Navigation ---
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

  // --- Card Sinh viên vắng mặt ---
  Widget _buildAbsentCard(Map<String, String> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Colors.red, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hàng tên + trạng thái ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  student["name"]!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  student["status"]!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              student["id"]!,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text(
              student["note"]!,
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Điểm danh thủ công",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
