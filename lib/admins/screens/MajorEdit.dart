import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Major.dart'; // Model ngành học
import '../models/Department.dart'; // Model bộ môn
import '../services/MajorService.dart';
import '../services/DepartmentService.dart';
import '../screens/MajorList.dart';

class MajorEdit extends StatefulWidget {
  final Major major; // Ngành học cần sửa
  const MajorEdit({Key? key, required this.major}) : super(key: key);

  @override
  State<MajorEdit> createState() => _MajorEditState();
}

class _MajorEditState extends State<MajorEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  final MajorService _majorService = MajorService();
  final DepartmentService _departmentService = DepartmentService();
  bool _isLoading = false;

  List<Department> _departments = [];
  Department? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.major.name);
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      // Tải danh sách bộ môn
      var result = await _departmentService.fetchDepartments(page: 1);
      setState(() {
        _departments = result['departments'];
        // Tìm và chọn bộ môn hiện tại của ngành học này
        if (_departments.isNotEmpty) {
          _selectedDepartment = _departments.firstWhere(
                (d) => d.id == widget.major.departmentId,
            orElse: () => _departments.first,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải danh sách bộ môn: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      await _majorService.updateMajor(
        id: widget.major.id,
        name: _nameController.text,
        departmentId: _selectedDepartment!.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật ngành học thành công!'),
            backgroundColor: Colors.green,
          ),
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
          const Sidebar(currentPage: 'Major'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Ngành học', subtitle: 'Sửa'),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.all(24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Form(
                            key: _formKey,
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
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const MajorList(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sửa ngành học',
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
                                      .map(
                                        (d) => DropdownMenuItem(
                                      value: d,
                                      child: Text('${d.name} - ${d.faculty?.name ?? 'N/A'}'),
                                    ),
                                  )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedDepartment = val),
                                  decoration: const InputDecoration(
                                    labelText: 'Chọn bộ môn',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) => val == null
                                      ? 'Vui lòng chọn bộ môn'
                                      : null,
                                ),
                                const SizedBox(height: 40),

                                // Nút Cập nhật
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
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
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}