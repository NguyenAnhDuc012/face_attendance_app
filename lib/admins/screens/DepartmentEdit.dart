import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Department.dart';
import '../models/Faculty.dart';
import '../services/DepartmentService.dart';
import '../services/FacultyService.dart';
import '../screens/DepartmentList.dart';

class DepartmentEdit extends StatefulWidget {
  final Department department;
  const DepartmentEdit({Key? key, required this.department}) : super(key: key);

  @override
  State<DepartmentEdit> createState() => _DepartmentEditState();
}

class _DepartmentEditState extends State<DepartmentEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final DepartmentService _departmentService = DepartmentService();
  final FacultyService _facultyService = FacultyService();
  bool _isLoading = false;

  List<Faculty> _faculties = [];
  Faculty? _selectedFaculty;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.department.name);
    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    try {
      // Tải danh sách khoa
      var result = await _facultyService.fetchFaculties(page: 1);
      setState(() {
        _faculties = result['faculties'];
        // Tìm và chọn khoa hiện tại của bộ môn này
        if (_faculties.isNotEmpty) {
          _selectedFaculty = _faculties.firstWhere(
            (f) => f.id == widget.department.facultyId,
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
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedFaculty == null) return;

    setState(() => _isLoading = true);

    try {
      await _departmentService.updateDepartment(
        id: widget.department.id,
        name: _nameController.text,
        facultyId: _selectedFaculty!.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật bộ môn thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DepartmentList()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi cập nhật bộ môn: $e'),
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
          const Sidebar(currentPage: 'Department'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Bộ môn', subtitle: 'Sửa'),
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
                                              const DepartmentList(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sửa bộ môn',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tên bộ môn',
                                    prefixIcon: Icon(Icons.business_center),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Vui lòng nhập tên bộ môn'
                                      : null,
                                ),
                                const SizedBox(height: 16),
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
                                  validator: (val) =>
                                      val == null ? 'Vui lòng chọn khoa' : null,
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
