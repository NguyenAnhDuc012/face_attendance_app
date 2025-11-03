import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Subject.dart';
import '../models/Department.dart';
import '../services/SubjectService.dart';
import '../services/DepartmentService.dart';
import '../screens/SubjectList.dart';

class SubjectEdit extends StatefulWidget {
  final Subject subject;
  const SubjectEdit({Key? key, required this.subject}) : super(key: key);

  @override
  State<SubjectEdit> createState() => _SubjectEditState();
}

class _SubjectEditState extends State<SubjectEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _creditsController;

  final SubjectService _subjectService = SubjectService();
  final DepartmentService _departmentService = DepartmentService();
  bool _isLoading = false;

  List<Department> _departments = [];
  Department? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
    _creditsController = TextEditingController(text: widget.subject.credits.toString());
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      // Tải danh sách bộ môn
      var result = await _departmentService.fetchDepartments(page: 1);
      setState(() {
        _departments = result['departments'];
        // Tìm và chọn bộ môn hiện tại của môn học này
        if (_departments.isNotEmpty) {
          _selectedDepartment = _departments.firstWhere(
                (d) => d.id == widget.subject.departmentId,
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
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDepartment == null) return;

    setState(() => _isLoading = true);

    try {
      final int credits = int.parse(_creditsController.text);

      await _subjectService.updateSubject(
        id: widget.subject.id,
        name: _nameController.text,
        credits: credits,
        departmentId: _selectedDepartment!.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật môn học thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SubjectList()),
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
          const Sidebar(currentPage: 'Subject'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Môn học', subtitle: 'Sửa'),
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
                                          const SubjectList(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sửa môn học',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),

                                // Tên môn học
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tên môn học',
                                    prefixIcon: Icon(Icons.book_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Vui lòng nhập tên môn học'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Số tín chỉ
                                TextFormField(
                                  controller: _creditsController,
                                  decoration: const InputDecoration(
                                    labelText: 'Số tín chỉ',
                                    prefixIcon: Icon(Icons.format_list_numbered),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập số tín chỉ';
                                    }
                                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                      return 'Số tín chỉ phải là số dương';
                                    }
                                    return null;
                                  },
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