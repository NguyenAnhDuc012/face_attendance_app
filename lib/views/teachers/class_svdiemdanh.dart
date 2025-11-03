import 'package:flutter/material.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AttendancePage(),
    );
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> students = List.generate(
    10,
        (index) => {
      "name": "Nguyễn Anh A",
      "id": "2251175761",
      "status": "Có mặt",
      "time": "lúc 07:58",
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
          "Điểm danh",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Card Thông tin lớp ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Danh sách điểm danh",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Lập trình Mobile",
                        style:
                        TextStyle(fontSize: 14, color: Colors.black54)),
                    Text("Ngày: 20/10/2025 | Thời gian kết thúc: 10:30",
                        style:
                        TextStyle(fontSize: 13, color: Colors.black45)),
                  ],
                ),
              ),
            ),
          ),

          // --- TabBar ---
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: "Có mặt (20)"),
              Tab(text: "Vắng mặt (20)"),
            ],
          ),

          // --- Danh sách sinh viên ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // --- Tab Có mặt ---
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: students.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final s = students[index];
                      return _buildStudentCard(s);
                    },
                  ),
                ),

                // --- Tab Vắng mặt ---
                const Center(child: Text("Chưa có sinh viên vắng mặt")),
              ],
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

  // --- Thẻ sinh viên ---
  Widget _buildStudentCard(Map<String, String> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: const Color(0xFF00B14F), // màu xanh sáng
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: const Icon(Icons.person_outline, color: Colors.black54),
        title: Text(
          student["name"]!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          student["id"]!,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              student["status"]!,
              style: const TextStyle(
                color: Color(0xFF00B14F), // xanh lá sáng
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              student["time"]!,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
