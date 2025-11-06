import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Đổi tên class để dễ phân biệt (ví dụ: StudentHeader)
class StudentHeader extends StatefulWidget implements PreferredSizeWidget {
  const StudentHeader({super.key});

  @override
  State<StudentHeader> createState() => _StudentHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StudentHeaderState extends State<StudentHeader> {
  // Đổi tên biến
  String _studentName = 'Đang tải...'; // Biến lưu tên sinh viên
  String _initials = ''; // Biến lưu chữ cái đầu

  @override
  void initState() {
    super.initState();
    _loadStudentInfo(); // Đổi tên hàm
  }

  // Đổi tên hàm và key SharedPreferences
  Future<void> _loadStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    // Lấy key của SINH VIÊN
    final fullName = prefs.getString('student_full_name');

    if (mounted) {
      setState(() {
        _studentName = fullName ?? 'Sinh viên'; // Đổi tên mặc định

        // Tính toán chữ cái đầu (logic giữ nguyên)
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
      // (Phần flexibleSpace, title, ... giữ nguyên)
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
            // Hiển thị loading (dùng biến _studentName)
            _studentName == 'Đang tải...'
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
                _studentName, // Hiển thị tên SINH VIÊN
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Avatar (logic giữ nguyên, dùng _initials)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue[700],
                child: _initials.isEmpty
                    ? const SizedBox()
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