import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../layouts/bottom_tab_nav.dart';
//Lớp học sắp tới
class CourseDetailStaticScreen extends StatefulWidget {
  final String courseName;
  final String className;

  const CourseDetailStaticScreen({
    super.key,
    required this.courseName,
    required this.className,
  });

  @override
  State<CourseDetailStaticScreen> createState() =>
      _CourseDetailStaticScreenState();
}

class _CourseDetailStaticScreenState extends State<CourseDetailStaticScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomNavIndex = 3; // tab “Lịch”

  // Dữ liệu mẫu
  final List<Map<String, dynamic>> allSessions = [
    {
      "sessionId": 1,
      "sessionDate": DateTime.now().add(const Duration(days: 1)),
      "startTime": "07:30",
      "endTime": "09:00",
      "roomName": "P101",
      "presentCount": 28,
      "totalStudents": 30,
      "statusText": "Chưa diễn ra",
      "statusColor": Colors.orange,
    },
    {
      "sessionId": 2,
      "sessionDate": DateTime.now().subtract(const Duration(days: 2)),
      "startTime": "09:30",
      "endTime": "11:00",
      "roomName": "P203",
      "presentCount": 27,
      "totalStudents": 30,
      "statusText": "Đã điểm danh",
      "statusColor": Colors.green,
    },
    {
      "sessionId": 3,
      "sessionDate": DateTime.now().add(const Duration(days: 5)),
      "startTime": "13:00",
      "endTime": "14:30",
      "roomName": "P102",
      "presentCount": 0,
      "totalStudents": 30,
      "statusText": "Chưa diễn ra",
      "statusColor": Colors.orange,
    },
  ];

  List<Map<String, dynamic>> _upcomingSessions = [];
  List<Map<String, dynamic>> _pastSessions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _processSessionData();
  }

  void _processSessionData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _upcomingSessions = allSessions
        .where((s) =>
    (s["sessionDate"] as DateTime).isAfter(today) ||
        (s["sessionDate"] as DateTime).isAtSameMomentAs(today))
        .toList();

    _pastSessions = allSessions
        .where((s) => (s["sessionDate"] as DateTime).isBefore(today))
        .toList();

    _upcomingSessions.sort(
            (a, b) => (a["sessionDate"] as DateTime).compareTo(b["sessionDate"]));
    _pastSessions.sort(
            (a, b) => (b["sessionDate"] as DateTime).compareTo(a["sessionDate"]));
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courseName,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Text(
              widget.className,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://placekitten.com/50/50'),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Sắp tới'),
            Tab(text: 'Đã qua'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSessionList(_upcomingSessions, "Chưa có buổi học nào sắp tới."),
          _buildSessionList(_pastSessions, "Chưa có buổi học nào đã qua."),
        ],
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: _bottomNavIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSessionList(
      List<Map<String, dynamic>> sessions, String emptyMessage) {
    if (sessions.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final String formattedDate =
    DateFormat('dd/MM/yyyy').format(session["sessionDate"]);
    final String subjectName = widget.courseName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Card(
          elevation: 0.5,
          margin: const EdgeInsets.only(bottom: 12.0),
          color: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thông tin lớp học
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${session["startTime"]} - ${session["endTime"]}',
                        style:
                        TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session["roomName"],
                        style:
                        TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Thông tin điểm danh
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Số lượng: ${session["presentCount"]}/${session["totalStudents"]}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session["statusText"],
                      style: TextStyle(
                        color: session["statusColor"],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text('Chi tiết'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CourseDetailStaticScreen(
      courseName: "Lập trình Flutter",
      className: "DHKTPM16B",
    ),
  ));
}
