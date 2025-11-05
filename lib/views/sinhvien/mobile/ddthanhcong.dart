import 'package:flutter/material.dart';

class DdThanhCong extends StatelessWidget {
  const DdThanhCong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          'Lập trình Mobile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,          // nhỏ hơn
            fontWeight: FontWeight.w500,
          ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs Sắp tới / Đã qua
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
            // 👆 đẩy hai tab gần giữa màn hình hơn
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TabItem(title: 'Sắp tới', isActive: true),
                _TabItem(title: 'Đã qua', isActive: false),
              ],
            ),
          ),
          const Divider(height: 1),

          // Thông báo điểm danh
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Bạn đã điểm danh thành công !',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Danh sách buổi học
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSessionCard(),
            ),
          ),
        ],
      ),

      // Thanh bottom navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  static Widget _buildSessionCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // xanh nhạt như trong ảnh
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buổi 10: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          const Text(
            '7:00 - 7:50\nPhòng 329 - A2',
            style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '64KTPM.NB\nTrạng thái: có mặt',
                style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
              ),
              Text(
                'Điểm danh kết thúc',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, size: 28, color: Color(0xFF0D47A1)),
          Icon(Icons.person_outline, size: 26, color: Colors.grey),
          Icon(Icons.chat_bubble_outline, size: 26, color: Colors.grey),
          Icon(Icons.calendar_today, size: 26, color: Colors.grey),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? Colors.black : Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        if (isActive)
          Container(
            height: 2.5,
            width: 55,
            color: const Color(0xFF1E3A8A),
          ),
      ],
    );
  }
}
