import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  const CustomHeader({super.key});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomHeaderState extends State<CustomHeader> {
  String _lecturerName = 'Đang tải...'; // Biến lưu tên giảng viên
  String _initials = ''; // Biến lưu chữ cái đầu

  @override
  void initState() {
    super.initState();
    _loadLecturerInfo();
  }

  // Hàm load thông tin từ SharedPreferences
  Future<void> _loadLecturerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('user_full_name');

    if (mounted) {
      setState(() {
        _lecturerName = fullName ?? 'Giảng viên';

        // Tính toán chữ cái đầu
        if (fullName != null && fullName.isNotEmpty) {
          _initials = fullName[0].toUpperCase();
        } else {
          _initials = '?';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Thêm một Container vào flexibleSpace để tạo đường kẻ xanh mỏng ở trên
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue, // Màu của đường kẻ
              width: 2.0, // Độ dày của đường kẻ
            ),
          ),
        ),
      ),
      title: const Text(
        'Trang chủ',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 1.0,
      iconTheme: const IconThemeData(color: Colors.blue),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Hiển thị loading nếu chưa tải xong
            _lecturerName == 'Đang tải...'
                ? const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                _lecturerName, // Hiển thị tên giảng viên
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis, // Chống vỡ layout nếu tên quá dài
              ),
            ),

            // Avatar
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue[700],
                // Hiển thị chữ cái đầu
                child: _initials.isEmpty
                    ? const SizedBox() // Hiển thị rỗng nếu _initials = ''
                    : Text(
                  _initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}