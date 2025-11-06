import 'package:face_attendance_app/students/screens/student_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../model/student_profile.dart';
import '../services/student_profile_service.dart';
import '../layouts/bottom_tab_nav.dart';

import '../services/student_profile_service.dart' show IP_MAY_CHU;

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  late Future<StudentProfile> _profileFuture;

  File? _pickedImage; // Ảnh mới chọn từ gallery
  String? _networkImageUrl; // Ảnh hiện tại trên server
  bool _isUploading = false; // Trạng thái đang tải lên

  @override
  void initState() {
    super.initState();
    _profileFuture = StudentProfileService.getProfile();
  }

  // Hàm chọn ảnh
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Nén ảnh
      );
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chọn ảnh: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Hàm tải ảnh lên
  Future<void> _uploadImage() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ảnh trước.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final newUrl = await StudentProfileService.uploadFaceImage(_pickedImage!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật ảnh thành công!'), backgroundColor: Colors.green),
      );

      // Cập nhật UI
      setState(() {
        _networkImageUrl = newUrl; // Hiển thị ảnh mới từ server
        _pickedImage = null; // Xóa ảnh preview
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Nút quay lại
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
            );
          },
        ),
        title: const Text(
          'Thông tin các nhân',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1.0,
        actions: [
          // Avatar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://picsum.photos/50/50'),
            ),
          ),
        ],
      ),
      body: FutureBuilder<StudentProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu.'));
          }

          final profile = snapshot.data!;
          // Gán ảnh từ server (chỉ 1 lần)
          if (_networkImageUrl == null && _pickedImage == null) {
            _networkImageUrl = profile.imageUrl;
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // ===== PHẦN TẢI ẢNH =====
              Center(
                child: Stack(
                  children: [
                    // Hiển thị ảnh
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      // Ưu tiên hiển thị ảnh mới chọn (preview)
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : (_networkImageUrl != null
                      // Thêm 'http://' + IP_MAY_CHU
                          ? NetworkImage('http://$IP_MAY_CHU$_networkImageUrl')
                          : null) as ImageProvider?,
                      // Icon fallback
                      child: (_pickedImage == null && _networkImageUrl == null)
                          ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                          : null,
                    ),
                    // Nút sửa
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        color: Colors.blue,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: _pickImage, // Gọi hàm chọn ảnh
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Tải lên (chỉ hiển thị nếu đã chọn ảnh mới)
              if (_pickedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadImage,
                    child: _isUploading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Tải ảnh lên'),
                  ),
                ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // ===== THÔNG TIN SINH VIÊN =====
              _buildInfoRow(Icons.person_outline, 'Họ và tên', profile.fullName),
              _buildInfoRow(Icons.email_outlined, 'Email', profile.email),
              _buildInfoRow(Icons.school_outlined, 'Lớp', profile.className),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomTabNav(
        currentIndex: 1, // Giả sử tab 'Cá nhân' là index 1
        onTap: (index) {
          // TODO: Thêm logic điều hướng
        },
      ),
    );
  }

  // Widget helper
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}