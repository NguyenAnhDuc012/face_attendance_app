import 'package:flutter/material.dart';

class BuoiHocDaQua extends StatefulWidget {
  const BuoiHocDaQua({super.key});

  @override
  State<BuoiHocDaQua> createState() => _BuoiHocDaQuaState();
}

class _BuoiHocDaQuaState extends State<BuoiHocDaQua>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
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
            fontWeight: FontWeight.w500, // mảnh hơn
            letterSpacing: 0.2,
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
        children: [
          // Tabs: Sắp tới / Đã qua
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF1E3A8A),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Sắp tới'),
                Tab(text: 'Đã qua'),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpcomingSessions(),
                _buildPastSessions(),
              ],
            ),
          ),
        ],
      ),

      // Thanh bottom navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ========== DANH SÁCH SẮP TỚI ==========
  Widget _buildUpcomingSessions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sessionCard(
            title: 'Buổi 10: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
            time: '7:00 - 7:50',
            room: 'Phòng 329 - A2',
            className: '64KTPM.NB',
            status: '?',
            color: const Color(0xFFE3F2FD),
            actionText: 'Điểm danh',
            actionColor: const Color(0xFF1565C0),
          ),
        ],
      ),
    );
  }

  // ========== DANH SÁCH ĐÃ QUA ==========
  Widget _buildPastSessions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sessionCard(
            title: 'Buổi 4: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
            time: '7:00 - 7:50',
            room: 'Phòng 329 - A2',
            className: '64KTPM.NB',
            status: 'có mặt',
            color: const Color(0xFFE8F5E9),
          ),
          _sessionCard(
            title: 'Buổi 3: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
            time: '7:00 - 7:50',
            room: 'Phòng 329 - A2',
            className: '64KTPM.NB',
            status: 'có mặt',
            color: const Color(0xFFE8F5E9),
          ),
          _sessionCard(
            title: 'Buổi 2: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
            time: '7:00 - 7:50',
            room: 'Phòng 329 - A2',
            className: '64KTPM.NB',
            status: 'vắng',
            color: const Color(0xFFFFEBEE),
          ),
          _sessionCard(
            title: 'Buổi 1: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
            time: '7:00 - 7:50',
            room: 'Phòng 329 - A2',
            className: '64KTPM.NB',
            status: 'muộn',
            color: const Color(0xFFFFF8E1),
          ),
        ],
      ),
    );
  }

  // ========== THẺ BUỔI HỌC ==========
  Widget _sessionCard({
    required String title,
    required String time,
    required String room,
    required String className,
    required String status,
    required Color color,
    String? actionText,
    Color? actionColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            '$time\n$room',
            style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                className,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                'Trạng thái: $status',
                style: const TextStyle(
                    color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          if (actionText != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: actionColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ========== BOTTOM NAV ==========
  Widget _buildBottomNav() {
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
