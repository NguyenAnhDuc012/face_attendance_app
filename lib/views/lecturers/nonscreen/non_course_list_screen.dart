import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../layouts/bottom_tab_nav.dart';
//Danh sách lớp học phần
class CourseListStaticScreen extends StatefulWidget {
  const CourseListStaticScreen({super.key});

  @override
  State<CourseListStaticScreen> createState() => _CourseListStaticScreenState();
}

class _CourseListStaticScreenState extends State<CourseListStaticScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 3; // tab “Lịch”
  late TabController _tabController;

  // Dữ liệu mẫu: mỗi lớp học phần có danh sách buổi học (sessions)
  final List<Map<String, dynamic>> dummyCourses = [
    {
      "subjectName": "Lập trình Flutter",
      "className": "DHKTPM16B",
      "sessions": [
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
          "sessionDate": DateTime.now().subtract(const Duration(days: 3)),
          "startTime": "09:30",
          "endTime": "11:00",
          "roomName": "P203",
          "presentCount": 27,
          "totalStudents": 30,
          "statusText": "Đã điểm danh",
          "statusColor": Colors.green,
        },
      ],
    },
    {
      "subjectName": "Phân tích thiết kế hệ thống",
      "className": "DHKTPM16A",
      "sessions": [
        {
          "sessionId": 3,
          "sessionDate": DateTime.now().add(const Duration(days: 4)),
          "startTime": "13:00",
          "endTime": "14:30",
          "roomName": "P102",
          "presentCount": 0,
          "totalStudents": 30,
          "statusText": "Chưa diễn ra",
          "statusColor": Colors.orange,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Hàm lọc buổi học theo tab
  List<Map<String, dynamic>> _filterSessions(List<Map<String, dynamic>> sessions, bool isUpcoming) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (isUpcoming) {
      return sessions
          .where((s) =>
      (s["sessionDate"] as DateTime).isAfter(today) ||
          (s["sessionDate"] as DateTime).isAtSameMomentAs(today))
          .toList()
        ..sort((a, b) =>
            (a["sessionDate"] as DateTime).compareTo(b["sessionDate"]));
    } else {
      return sessions
          .where((s) => (s["sessionDate"] as DateTime).isBefore(today))
          .toList()
        ..sort((a, b) =>
            (b["sessionDate"] as DateTime).compareTo(a["sessionDate"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách lớp học phần',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://placekitten.com/50/50'),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCourseList(isUpcoming: true),
          _buildCourseList(isUpcoming: false),
        ],
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCourseList({required bool isUpcoming}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: dummyCourses.length,
      itemBuilder: (context, index) {
        final course = dummyCourses[index];
        final filteredSessions =
        _filterSessions(course["sessions"], isUpcoming);

        if (filteredSessions.isEmpty) {
          return const SizedBox.shrink(); // Bỏ qua lớp không có buổi phù hợp
        }

        return _buildCourseCard(course, filteredSessions);
      },
    );
  }

  Widget _buildCourseCard(
      Map<String, dynamic> course, List<Map<String, dynamic>> sessions) {
    return Card(
      elevation: 0.8,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên lớp
            Text(
              course["subjectName"],
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              course["className"],
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const Divider(height: 20, color: Colors.black26),
            // Danh sách buổi học
            ...sessions.map((session) => _buildSessionItem(session)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session) {
    final formattedDate =
    DateFormat('dd/MM/yyyy').format(session["sessionDate"]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Thông tin buổi học
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text('${session["startTime"]} - ${session["endTime"]}'),
              Text(session["roomName"]),
            ],
          ),
          // Trạng thái
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${session["presentCount"]}/${session["totalStudents"]}',
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                session["statusText"],
                style: TextStyle(
                    color: session["statusColor"],
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CourseListStaticScreen(),
  ));
}
