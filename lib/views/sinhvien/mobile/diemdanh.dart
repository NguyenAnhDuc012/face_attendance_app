import 'package:flutter/material.dart';

class DiemDanhScreen extends StatefulWidget {
  const DiemDanhScreen({super.key});

  @override
  State<DiemDanhScreen> createState() => _DiemDanhScreenState();
}

class _DiemDanhScreenState extends State<DiemDanhScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedStatus; // lưu trạng thái được chọn (có mặt / muộn / vắng)

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
            fontSize: 16,
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
        children: [
          // Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF1E3A8A),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Thủ công'),
                Tab(text: 'Quét QR'),
              ],
            ),
          ),
          const Divider(height: 1),

          // Nội dung 2 tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildThuCongTab(),
                _buildQuetQRTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================== TAB THỦ CÔNG ==================
  Widget _buildThuCongTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn trạng thái điểm danh cho buổi học:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          const Text(
            'Buổi 10: Tuần 2 (Thứ 2, Ngày 10/12/2025)',
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
          const SizedBox(height: 16),

          _attendanceOption(
            title: 'Có mặt',
            subtitle: 'Bạn có mặt tại lớp',
            color: const Color(0xFFE8F5E9),
            value: 'comat',
            icon: Icons.check_circle_outline,
          ),
          _attendanceOption(
            title: 'Muộn',
            subtitle: 'Bạn có mặt tại lớp',
            color: const Color(0xFFFFF8E1),
            value: 'muon',
            icon: Icons.access_time,
          ),
          _attendanceOption(
            title: 'Vắng',
            subtitle: 'Bạn có mặt tại lớp',
            color: const Color(0xFFFFEBEE),
            value: 'vang',
            icon: Icons.cancel_outlined,
          ),

          const SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceOption({
    required String title,
    required String subtitle,
    required Color color,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedStatus == value
              ? const Color(0xFF1565C0)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                Text(subtitle,
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          Radio<String>(
            value: value,
            groupValue: selectedStatus,
            onChanged: (val) {
              setState(() => selectedStatus = val);
            },
            activeColor: const Color(0xFF1565C0),
          ),
        ],
      ),
    );
  }

  // ================== TAB QUÉT QR ==================
  Widget _buildQuetQRTab() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Lấy mặt trước',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.close, color: Colors.white, size: 26),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              color: const Color(0xFF2C2C2C),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.flash_off, color: Colors.white, size: 28),
                  Icon(Icons.camera_alt, color: Colors.white, size: 34),
                  Icon(Icons.photo_library_outlined,
                      color: Colors.white, size: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  }
