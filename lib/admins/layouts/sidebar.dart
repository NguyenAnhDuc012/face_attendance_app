// lib/widgets/sidebar.dart
import 'package:face_attendance_app/admins/screens/AcademicYearList.dart';
import 'package:face_attendance_app/admins/screens/DepartmentList.dart';
import 'package:face_attendance_app/admins/screens/FacilityList.dart';
import 'package:face_attendance_app/admins/screens/FacultyList.dart';
import 'package:face_attendance_app/admins/screens/RoomList.dart';
import 'package:face_attendance_app/admins/screens/SemesterList.dart';
import 'package:face_attendance_app/admins/screens/StudentClassList.dart';
import 'package:face_attendance_app/admins/screens/StudentList.dart';
import 'package:flutter/material.dart';

import '../screens/IntakeList.dart';

class Sidebar extends StatelessWidget {
  final String currentPage;

  const Sidebar({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF343A40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Phòng đào tạo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildNavItem(
            Icons.dashboard,
            'Khóa học',
            'Intake' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.category,
            'Năm học',
            'Academic Year' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.discount,
            'Học kỳ',
            'Semester' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.account_tree,
            'Cơ sở đào tạo',
            'Facility' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.local_shipping,
            'Khoa',
            'Faculty' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.local_shipping,
            'Bộ môn',
            'Department' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.copyright,
            'Phòng học',
            'Room' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.inventory_2,
            'Lớp học',
            'StudentClass' == currentPage,
            context,
          ),
          _buildNavItem(
            Icons.shopping_cart,
            'Sinh viên',
            'Student' == currentPage,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String title,
    bool isActive,
    BuildContext context,
  ) {
    return Container(
      color: isActive ? Colors.black.withOpacity(0.3) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: isActive ? Colors.white : Colors.grey[400]),
        title: Text(
          title,
          style: TextStyle(color: isActive ? Colors.white : Colors.grey[400]),
        ),
        onTap: () {
          switch (title) {
            case 'Khóa học':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const IntakeList()),
              );
              break;
            case 'Năm học':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AcademicYearList(),
                ),
              );
              break;
            case 'Cơ sở đào tạo':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FacilityList()),
              );
              break;
            case 'Khoa':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FacultyList()),
              );
              break;
            case 'Phòng học':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RoomList()),
              );
              break;
            case 'Lớp học':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentClassList(),
                ),
              );
              break;
            case 'Sinh viên':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentList(),
                ),
              );
              break;
            case 'Học kỳ':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SemesterList(),
                ),
              );
              break;
            case 'Bộ môn':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DepartmentList(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
