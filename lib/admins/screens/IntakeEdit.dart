import 'package:face_attendance_app/admins/screens/IntakeList.dart';
import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Intake.dart';
import '../services/IntakeService.dart';

class IntakeEdit extends StatefulWidget {
  final Intake intake;
  const IntakeEdit({Key? key, required this.intake}) : super(key: key);

  @override
  State<IntakeEdit> createState() => _IntakeEditState();
}

class _IntakeEditState extends State<IntakeEdit> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.intake.name);
  late final _startYearController = TextEditingController(
    text: widget.intake.startYear.toString(),
  );
  late final _expectedYearController = TextEditingController(
    text: widget.intake.expectedGraduationYear.toString(),
  );

  final IntakeService _service = IntakeService();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _startYearController.dispose();
    _expectedYearController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _service.updateIntake(
        id: widget.intake.id,
        name: _nameController.text,
        startYear: int.parse(_startYearController.text),
        expectedGraduationYear: int.parse(_expectedYearController.text),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sửa khóa học thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IntakeList()),
      ); // quay về danh sách
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tạo khóa học: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentPage: 'Intake'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Khóa học', subtitle: 'Sửa'),
                Expanded(
                  // Căn giữa nội dung và giới hạn chiều rộng
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      // Sử dụng Card để tạo hiệu ứng "nổi" và có viền
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.all(24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          // Tăng padding bên trong Card
                          padding: const EdgeInsets.all(32.0),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const IntakeList(),
                                          ),
                                        ); // quay về màn hình danh sách
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),

                                  const SizedBox(height: 16),
                                  // Sửa tiêu đề cho Form
                                  Text(
                                    'Sửa khóa học mới',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),

                                  // Trường Tên khóa học
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Tên khóa học',
                                      prefixIcon: Icon(Icons.school_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Vui lòng nhập tên khóa'
                                        : null,
                                  ),
                                  const SizedBox(height: 20),

                                  // Trường Năm bắt đầu
                                  TextFormField(
                                    controller: _startYearController,
                                    decoration: const InputDecoration(
                                      labelText: 'Năm bắt đầu',
                                      prefixIcon: Icon(
                                        Icons.calendar_today_outlined,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập năm bắt đầu';
                                      }
                                      final year = int.tryParse(value);
                                      if (year == null || year < 1900) {
                                        return 'Năm không hợp lệ';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Trường Năm kết thúc
                                  TextFormField(
                                    controller: _expectedYearController,
                                    decoration: const InputDecoration(
                                      labelText: 'Năm kết thúc dự kiến',
                                      prefixIcon: Icon(
                                        Icons.calendar_month_outlined,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập năm kết thúc';
                                      }
                                      final year = int.tryParse(value);
                                      final startYear = int.tryParse(
                                        _startYearController.text,
                                      );
                                      if (year == null ||
                                          startYear == null ||
                                          year < startYear) {
                                        return 'Năm kết thúc phải >= năm bắt đầu';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 40),

                                  // Nút bấm
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
