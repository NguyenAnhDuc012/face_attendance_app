import 'package:flutter/material.dart';

void main() {
  runApp(const ClassListPage());
}

class ClassListPage extends StatelessWidget {
  const ClassListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ClassListScreen(),
    );
  }
}

class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "Danh sách lớp học",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            CourseCard(
              title: "Học tăng cường và ứng dụng",
              code: "64KTPM.NB",
            ),
            SizedBox(height: 12),
            CourseCard(
              title: "Lập trình Web",
              code: "64KTPM 1",
            ),
            SizedBox(height: 12),
            CourseCard(
              title: "Tư tưởng Hồ Chí minh",
              code: "64KTPM 2",
            ),
            SizedBox(height: 12),
            CourseCard(
              title: "Tương tác người máy",
              code: "64KTPM 3",
            ),
            SizedBox(height: 12),
            CourseCard(
              title: "Kiểm thử phần mềm",
              code: "64KTPM.NB",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF205BF3),
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
}

class CourseCard extends StatelessWidget {
  final String title;
  final String code;

  const CourseCard({
    super.key,
    required this.title,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(code, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF205BF3),
                borderRadius: BorderRadius.circular(6),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: const Text(
                "Chi tiết",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
