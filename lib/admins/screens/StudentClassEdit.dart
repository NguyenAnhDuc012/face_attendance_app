import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/StudentClass.dart';
import '../services/StudentClassService.dart';
import 'StudentClassList.dart';

class StudentClassEdit extends StatefulWidget {
  final StudentClass studentClass;
  const StudentClassEdit({Key? key, required this.studentClass}) : super(key: key);

  @override
  State<StudentClassEdit> createState() => _StudentClassEditState();
}

class _StudentClassEditState extends State<StudentClassEdit> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.studentClass.name);
  final StudentClassService _service = StudentClassService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _service.updateStudentClass(id: widget.studentClass.id, name: _nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sửa lớp học thành công!'), backgroundColor: Colors.green));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentClassList()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi sửa lớp học: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentPage: 'StudentClass'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Lớp học', subtitle: 'Sửa'),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.all(24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentClassList())),
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Sửa lớp học', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 32),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(labelText: 'Tên lớp', prefixIcon: Icon(Icons.class_), border: OutlineInputBorder()),
                                    validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên lớp' : null,
                                  ),
                                  const SizedBox(height: 40),
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                        : const Text('Cập nhật', style: TextStyle(fontSize: 16)),
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
