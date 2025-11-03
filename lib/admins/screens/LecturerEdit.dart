import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Lecturer.dart'; // Model giảng viên
import '../models/Faculty.dart'; // Model khoa
import '../services/LecturerService.dart';
import '../services/FacultyService.dart';
import '../screens/LecturerList.dart';

class LecturerEdit extends StatefulWidget {
  final Lecturer lecturer; // Giảng viên cần sửa
  const LecturerEdit({Key? key, required this.lecturer}) : super(key: key);

  @override
  State<LecturerEdit> createState() => _LecturerEditState();
}

class _LecturerEditState extends State<LecturerEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final LecturerService _lecturerService = LecturerService();
  final FacultyService _facultyService = FacultyService();

  bool _isLoading = false;
  List<Faculty> _faculties = [];
  Faculty? _selectedFaculty;

  @override
  void initState() {
    super.initState();
    // Gán giá trị ban đầu từ widget.lecturer
    _fullNameController = TextEditingController(text: widget.lecturer.fullName);
    _emailController = TextEditingController(text: widget.lecturer.email);
    _phoneController = TextEditingController(text: widget.lecturer.phone ?? '');

    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    try {
      var result = await _facultyService.fetchFaculties(page: 1);
      setState(() {
        _faculties = result['faculties'];
        if (_faculties.isNotEmpty) {
          _selectedFaculty = _faculties.firstWhere(
            (f) => f.id == widget.lecturer.facultyId,
            orElse: () => _faculties.first,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải danh sách khoa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedFaculty == null) return;

    setState(() => _isLoading = true);

    final String? newPassword = _passwordController.text.isNotEmpty
        ? _passwordController.text
        : null;

    try {
      await _lecturerService.updateLecturer(
        id: widget.lecturer.id,
        fullName: _fullNameController.text,
        facultyId: _selectedFaculty!.id,
        email: _emailController.text,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        password: newPassword,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật giảng viên thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LecturerList()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi cập nhật: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentPage: 'Lecturer'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Giảng viên', subtitle: 'Sửa'),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              // Cho phép cuộn
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LecturerList()),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Sửa thông tin giảng viên',
                                    // ... (Code style Text) ...
                                  ),
                                  const SizedBox(height: 32),

                                  // Dropdown chọn Khoa
                                  DropdownButtonFormField<Faculty>(
                                    value: _selectedFaculty,
                                    items: _faculties
                                        .map(
                                          (f) => DropdownMenuItem(
                                            value: f,
                                            child: Text(
                                              '${f.name} - ${f.facility?.name ?? 'N/A'}',
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedFaculty = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn khoa',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) => val == null
                                        ? 'Vui lòng chọn khoa'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Họ tên
                                  TextFormField(
                                    controller: _fullNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Họ và tên',
                                      prefixIcon: Icon(Icons.person_outline),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Vui lòng nhập họ tên'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Email
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Vui lòng nhập email';
                                      if (!value.contains('@'))
                                        return 'Email không hợp lệ';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Số điện thoại
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Số điện thoại (Tùy chọn)',
                                      prefixIcon: Icon(Icons.phone_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Mật khẩu mới
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Mật khẩu mới',
                                      hintText: 'Bỏ trống nếu không đổi',
                                      prefixIcon: Icon(Icons.lock_outline),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value != null &&
                                          value.isNotEmpty &&
                                          value.length < 6) {
                                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Xác nhận Mật khẩu mới
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Xác nhận mật khẩu mới',
                                      prefixIcon: Icon(Icons.lock_outline),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return 'Mật khẩu không khớp';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 40),
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : const Text(
                                            'Cập nhật',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
