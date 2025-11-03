import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../services/MajorService.dart';
import '../services/DepartmentService.dart';
import '../models/Department.dart';
import '../screens/MajorList.dart';

class MajorCreate extends StatefulWidget {
  const MajorCreate({Key? key}) : super(key: key);

  @override
  State<MajorCreate> createState() => _MajorCreateState();
}

class _MajorCreateState extends State<MajorCreate> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final MajorService _majorService = MajorService();
  final DepartmentService _departmentService = DepartmentService(); // Service Bộ môn

  bool _isLoading = false;
  Department? _selectedDepartment; // Bộ môn được chọn
  List<Department> _departments = []; // Danh sách bộ môn

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      // Tải trang đầu tiên của danh sách bộ môn
      var result = await _departmentService.fetchDepartments(page: 1);
      setState(() {
        _departments = result['departments'];
        if (_departments.isNotEmpty) _selectedDepartment = _departments.first;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi khi tải bộ môn: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
    // TODO: Cân nhắc tải tất cả bộ môn nếu danh sách quá dài
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDepartment == null) return;

    setState(() => _isLoading = true);

    try {
      await _majorService.createMajor(
          name: _nameController.text,
          departmentId: _selectedDepartment!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tạo ngành học thành công!'),
              backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MajorList()),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst("Exception: ", "");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red),
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
          const Sidebar(currentPage: 'Major'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Ngành học', subtitle: 'Thêm mới'),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.all(24.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min, // Giúp card co lại
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const MajorList()),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Thêm ngành học mới',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),

                                // Tên ngành học
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tên ngành học',
                                    prefixIcon: Icon(Icons.school_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Vui lòng nhập tên ngành học'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Dropdown chọn Bộ môn
                                DropdownButtonFormField<Department>(
                                  value: _selectedDepartment,
                                  items: _departments
                                      .map((d) => DropdownMenuItem(
                                    value: d,
                                    // Hiển thị: "Bộ môn - Khoa"
                                    child: Text('${d.name} - ${d.faculty?.name ?? 'N/A'}'),
                                  ))
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedDepartment = val),
                                  decoration: const InputDecoration(
                                    labelText: 'Chọn bộ môn',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) =>
                                  val == null ? 'Vui lòng chọn bộ môn' : null,
                                ),
                                const SizedBox(height: 40),

                                // Nút Submit
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3),
                                  )
                                      : const Text('Tạo mới',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ],
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