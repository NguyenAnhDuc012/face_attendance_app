import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/student.dart';
import '../services/student_auth_service.dart';
import 'student_home_screen.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Gọi service của Student
      final Student student = await StudentAuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('student_id', student.id);
      await prefs.setString('student_email', student.email);
      await prefs.setString('student_full_name', student.fullName);

      // Lấy tên lớp từ model (API đã trả về)
      final className = student.studentClass?.name ?? 'Chưa có lớp';
      await prefs.setString('student_class_name', className);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đăng nhập thành công! Xin chào ${student.fullName}',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Điều hướng đến màn hình Home của Student
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.top,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/images/icon_tlu.png'),
                  ),
                  const SizedBox(height: 32.0),
                  Center(
                    child: Text(
                      'Đăng nhập Sinh viên', // Sửa tiêu đề
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _emailController, // Đúng
                    decoration: const InputDecoration(
                      hintText: 'Nhập email tại đây',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) { /* ... (validator của bạn) ... */ },
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Mật khẩu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController, // Đúng
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu tại đây',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) { /* ... (validator của bạn) ... */ },
                  ),
                  const SizedBox(height: 40.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login, // Đúng
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B6BFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}