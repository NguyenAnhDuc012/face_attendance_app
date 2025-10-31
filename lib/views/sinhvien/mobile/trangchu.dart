import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrangChu extends StatelessWidget {
  const TrangChu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // ======== APP BAR ========
            Container(
              color: const Color(0xFF0D47A1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.white, size: 28),
                  Text(
                    'Trang chủ',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,          // nhỏ hơn
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ],
              ),
            ),

            // ======== THÔNG TIN NGƯỜI DÙNG ========
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chào Nguyễn Văn A!',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MSSV: 2251177753\nLớp: 64KTPM',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ======== LỊCH HỌC HÔM NAY ========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lịch học hôm nay',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // ======== DANH SÁCH MÔN HỌC ========
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // --- Môn 1 ---
                    _buildCourseCard(
                      title: 'Lập trình ứng dụng\ncho các thiết bị di động',
                      className: '64KTPM.NB',
                      time: '7:00 - 7:50',
                      room: 'Phòng 329 - A2',
                      statusText: 'Trạng thái: có mặt',
                      noteText: 'Điểm danh kết thúc',
                      color: const Color(0xFFDFF4E2), // xanh lá nhạt
                      buttonText: null,
                    ),
                    const SizedBox(height: 12),

                    // --- Môn 2 ---
                    _buildCourseCard(
                      title: 'Học tăng cường và\nứng dụng',
                      className: '64KTPM1',
                      time: '7:55 - 8:50',
                      room: 'Phòng 329 - A2',
                      statusText: 'Trạng thái: ?',
                      noteText: null,
                      color: const Color(0xFFE8F0FE), // xanh nhạt
                      buttonText: 'Điểm danh',
                    ),
                    const SizedBox(height: 12),

                    // --- Môn 3 ---
                    _buildCourseCard(
                      title: 'Tư tưởng Hồ Chí Minh',
                      className: '64KTPM2',
                      time: '8:55 - 10:50',
                      room: 'Phòng 329 - A2',
                      statusText: 'Trạng thái: ?',
                      noteText: 'Lớp chưa mở',
                      color: const Color(0xFFEAF4FF), // xanh lam rất nhạt
                      buttonText: null,
                    ),
                  ],
                ),
              ),
            ),

            // ======== THANH ICON DƯỚI CÙNG ========
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.home, size: 28, color: Color(0xFF0D47A1)),
                  Icon(Icons.person_outline, size: 26, color: Colors.grey),
                  Icon(Icons.chat_bubble_outline, size: 26, color: Colors.grey),
                  Icon(Icons.calendar_today, size: 26, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======== HÀM TẠO THẺ MÔN HỌC ========
  Widget _buildCourseCard({
    required String title,
    required String className,
    required String time,
    required String room,
    required String statusText,
    String? noteText,
    required Color color,
    String? buttonText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dòng đầu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                className,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Trạng thái
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (buttonText != null)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            time,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
          Text(
            room,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
          if (noteText != null) ...[
            const SizedBox(height: 6),
            Text(
              noteText,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
