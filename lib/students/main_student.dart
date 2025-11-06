import 'package:face_attendance_app/lecturers/screens/Login.dart';
import 'package:face_attendance_app/students/screens/student_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Đảm bảo thanh trạng thái có màu nền sáng (chữ và icon màu đen)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent, // Trong suốt để thấy màu AppBar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Đặt màu nền chung của ứng dụng cho giống với ảnh
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        fontFamily: 'Inter',
      ),
      home: const StudentLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}