import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../layouts/bottom_tab_nav.dart';
import '../model/session_detail.dart';
import '../services/session_service.dart';
import 'session_detail_screen.dart';

class QrCodeScreen extends StatefulWidget {
  final String qrToken;
  final SessionDetail sessionDetail;
  final int durationMinutes;

  const QrCodeScreen({
    super.key,
    required this.qrToken,
    required this.sessionDetail,
    required this.durationMinutes,
  });

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  late Timer _timer;
  late Duration _timeRemaining;
  bool _isEnding = false; // State cho nút "Kết thúc"

  @override
  void initState() {
    super.initState();
    // Bắt đầu đếm ngược
    _timeRemaining = Duration(minutes: widget.durationMinutes);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.inSeconds == 0) {
        timer.cancel();
        // Tự động pop về khi hết giờ
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          setState(() {
            _timeRemaining = _timeRemaining - const Duration(seconds: 1);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy timer khi màn hình đóng
    super.dispose();
  }

  // Hàm helper để format (VD: 15:00 -> 14:59)
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // Hàm gọi API kết thúc (copy từ SessionDetailScreen)
  Future<void> _endSession() async {
    setState(() => _isEnding = true);

    try {
      await SessionService.endAttendance(
        sessionId: widget.sessionDetail.sessionId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã kết thúc buổi điểm danh.'),
            backgroundColor: Colors.blue,
          ),
        );

        // Quay về màn hình chi tiết (đã được refresh)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SessionDetailScreen(
            sessionId: widget.sessionDetail.sessionId,
            courseId: 0, // Tạm (cần truyền từ màn hình trước)
            courseName: widget.sessionDetail.courseName,
            className: widget.sessionDetail.className,
          )),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isEnding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            // TODO: Hỏi xác nhận "Bạn muốn dừng điểm danh?"
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Điểm danh QR'),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Thẻ thông tin buổi học
          _buildSessionInfoCard(widget.sessionDetail),
          const SizedBox(height: 32),

          // 2. Mã QR Code
          Center(
            child: QrImageView(
              data: widget.qrToken, // Dữ liệu QR là token
              version: QrVersions.auto,
              size: 250.0,
              gapless: false,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // 3. Đồng hồ đếm ngược
          Center(
            child: Column(
              children: [
                Text(
                  'Thời gian còn lại:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _formatDuration(_timeRemaining),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    // Đổi màu đỏ khi còn dưới 1 phút
                    color: _timeRemaining.inMinutes < 1 ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 4. Nút Kết thúc
          ElevatedButton(
            onPressed: _isEnding ? null : _endSession,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: _isEnding
                ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            )
                : const Text(
              'Kết thúc điểm danh',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: 3, // Giả sử tab 'Lịch' là index 3
        onTap: (index) {},
      ),
    );
  }

  // (Đây là hàm copy từ SessionDetailScreen để hiển thị thẻ info)
  Widget _buildSessionInfoCard(SessionDetail session) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lớp học hiện tại',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${session.courseName} - ${session.className}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                session.sessionDate,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${session.startTime} - ${session.endTime}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                session.roomName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}