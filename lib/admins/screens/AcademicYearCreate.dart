import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../services/AcademicYearService.dart';
import 'AcademicYearList.dart';

class AcademicYearCreate extends StatefulWidget {
  const AcademicYearCreate({Key? key}) : super(key: key);

  @override
  State<AcademicYearCreate> createState() => _AcademicYearCreateState();
}

class _AcademicYearCreateState extends State<AcademicYearCreate> {
  final _formKey = GlobalKey<FormState>();
  final _startYearController = TextEditingController();
  final _endYearController = TextEditingController();
  final AcademicYearService _service = AcademicYearService();

  bool _isLoading = false;

  @override
  void dispose() {
    _startYearController.dispose();
    _endYearController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _service.createAcademicYear(
        startYear: int.parse(_startYearController.text),
        endYear: int.parse(_endYearController.text),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tạo năm học thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AcademicYearList()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tạo năm học: $e'),
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
          const Sidebar(currentPage: 'Academic Year'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Năm học', subtitle: 'Thêm mới'),
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
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AcademicYearList(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Thêm năm học mới',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),
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
                                  TextFormField(
                                    controller: _endYearController,
                                    decoration: const InputDecoration(
                                      labelText: 'Năm kết thúc',
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
                                      final endYear = int.tryParse(value);
                                      final startYear = int.tryParse(
                                        _startYearController.text,
                                      );
                                      if (endYear == null ||
                                          startYear == null ||
                                          endYear < startYear) {
                                        return 'Năm kết thúc phải >= năm bắt đầu';
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
                                            'Tạo mới',
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
