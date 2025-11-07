import 'package:face_attendance_app/students/screens/student_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

// 2. TẠO BIẾN GLOBAL ĐỂ LƯU DANH SÁCH CAMERA
late List<CameraDescription> cameras;

// 3. CHUYỂN main() THÀNH Future<void> main() async
Future<void> main() async {
  // 4. THÊM 2 DÒNG NÀY ĐỂ KHỞI TẠO
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras(); // Lấy danh sách camera
  } on CameraException catch (e) {
    print('Lỗi khi lấy danh sách camera: ${e.code}: ${e.description}');
    cameras = []; // Khởi tạo rỗng nếu có lỗi
  }

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