import 'package:flutter/material.dart';

class DsLopHoc extends StatelessWidget {
  const DsLopHoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        title: const Text(
          'Danh sách lớp học',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,          // nhỏ hơn
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 16,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildClassCard('Học tăng cường và ứng dụng', '64KTPM.NB'),
            _buildClassCard('Lập trình Web', '64KTPM 1'),
            _buildClassCard('Tư tưởng Hồ Chí Minh', '64KTPM 2'),
            _buildClassCard('Tương tác người máy', '64KTPM 3'),
            _buildClassCard('Kiểm thử phần mềm', '64KTPM.NB'),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildClassCard(String title, String classCode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            classCode,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            ),
            child: const Text(
              'Chi tiết',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, size: 28, color: Color(0xFF0D47A1)),
          Icon(Icons.person_outline, size: 26, color: Colors.grey),
          Icon(Icons.chat_bubble_outline, size: 26, color: Colors.grey),
          Icon(Icons.calendar_today, size: 26, color: Colors.grey),
        ],
      ),
    );
  }
}
