import 'package:face_attendance_app/admins/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'screens/IntakeCreate.dart';
import 'screens/IntakeEdit.dart';
import 'screens/IntakeList.dart';

void main() {
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardColor: Colors.white,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
        },
      ),
      home: const LoginPage(),
    );
  }
}
