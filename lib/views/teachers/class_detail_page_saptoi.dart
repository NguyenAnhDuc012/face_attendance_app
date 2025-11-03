import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClassDetailPage(),
    );
  }
}

class ClassDetailPage extends StatefulWidget {
  const ClassDetailPage({super.key});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> upcomingSessions = [
    {
      'title': 'Buổi 10: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
      'time': '7:00 - 7:50',
      'room': 'Phòng 329 - A2',
      'classCode': '64KTPM.NB',
      'status': 'Lớp chưa mở'
    },
    {
      'title': 'Buổi 11: Tuần 3 (Thứ 2, Ngày 17/12/2025)',
      'time': '7:00 - 7:50',
      'room': 'Phòng 329 - A2',
      'classCode': '64KTPM.NB',
      'status': 'Lớp chưa mở'
    },
  ];

  final List<Map<String, String>> pastSessions = [
    {
      'title': 'Buổi 8: Tuần 1 (Thứ 2, Ngày 03/12/2025)',
      'time': '7:00 - 7:50',
      'room': 'Phòng 329 - A2',
      'classCode': '64KTPM.NB',
      'status': 'Đã học'
    },
    {
      'title': 'Buổi 9: Tuần 1 (Thứ 4, Ngày 05/12/2025)',
      'time': '7:00 - 7:50',
      'room': 'Phòng 329 - A2',
      'classCode': '64KTPM.NB',
      'status': 'Đã học'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lập trình Mobile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () {},
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          tabs: const [
            Tab(text: "Sắp tới"),
            Tab(text: "Đã qua"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSessionList(upcomingSessions),
          _buildSessionList(pastSessions),
        ],
      ),bottomNavigationBar: BottomNavigationBar(
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

  Widget _buildSessionList(List<Map<String, String>> sessions) {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${session['time']}\n${session['room']}",
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      session['classCode']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      session['status']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: session['status'] == 'Đã học'
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Trạng thái: ?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
