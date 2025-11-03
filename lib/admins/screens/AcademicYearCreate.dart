import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../services/AcademicYearService.dart';
import 'AcademicYearList.dart';
import 'package:intl/intl.dart';

class AcademicYearCreate extends StatefulWidget {
  const AcademicYearCreate({Key? key}) : super(key: key);

  @override
  State<AcademicYearCreate> createState() => _AcademicYearCreateState();
}

class _AcademicYearCreateState extends State<AcademicYearCreate> {
  final _formKey = GlobalKey<FormState>();
  final _startYearController = TextEditingController();
  final _endYearController = TextEditingController();

  // Controller chỉ dùng để hiển thị
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // State để lưu giá trị ngày thật
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  bool _isActive = false;
  final AcademicYearService _service = AcademicYearService();
  bool _isLoading = false;

  @override
  void dispose() {
    _startYearController.dispose();
    _endYearController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // --- HÀM HELPER ĐÃ CẬP NHẬT ---
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initial = isStartDate
        ? (_selectedStartDate ?? DateTime.now())
        : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Định dạng ngày hiển thị DD/MM/YYYY
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked); // <-- CẬP NHẬT

      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked; // Lưu đối tượng DateTime
          _startDateController.text = formattedDate; // Hiển thị
        } else {
          _selectedEndDate = picked; // Lưu đối tượng DateTime
          _endDateController.text = formattedDate; // Hiển thị
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Helper để chuyển DateTime về YYYY-MM-DD cho service
    String? formatDateForService(DateTime? date) {
      if (date == null) return null;
      return DateFormat('yyyy-MM-dd').format(date); // <-- CẬP NHẬT
    }

    try {
      await _service.createAcademicYear(
        startYear: int.parse(_startYearController.text),
        endYear: int.parse(_endYearController.text),

        // Gửi ngày đã định dạng cho service
        startDate: formatDateForService(_selectedStartDate), // <-- CẬP NHẬT
        endDate: formatDateForService(_selectedEndDate),     // <-- CẬP NHẬT
        isActive: _isActive,
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
      final errorMessage = e.toString().replaceFirst("Exception: ", "");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tạo năm học: $errorMessage'),
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

                                  // Năm BĐ
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

                                  // Năm KT
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
                                  const SizedBox(height: 20),

                                  // --- WIDGET ĐÃ CẬP NHẬT ---
                                  // Ngày BĐ
                                  TextFormField(
                                    controller: _startDateController, // Chỉ hiển thị
                                    decoration: const InputDecoration(
                                      labelText: 'Ngày bắt đầu (Tùy chọn)',
                                      hintText: 'dd/mm/yyyy', // Gợi ý
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: true,
                                    onTap: () => _selectDate(context, true), // true = isStartDate
                                  ),
                                  const SizedBox(height: 20),

                                  // Ngày KT
                                  TextFormField(
                                    controller: _endDateController, // Chỉ hiển thị
                                    decoration: const InputDecoration(
                                      labelText: 'Ngày kết thúc (Tùy chọn)',
                                      hintText: 'dd/mm/yyyy', // Gợi ý
                                      prefixIcon: Icon(Icons.date_range_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: true,
                                    onTap: () => _selectDate(context, false), // false = isEndDate
                                    validator: (value) {
                                      // Validate trực tiếp bằng 2 đối tượng DateTime
                                      if (_selectedStartDate != null && _selectedEndDate != null) {
                                        if (_selectedEndDate!.isBefore(_selectedStartDate!)) {
                                          return 'Ngày kết thúc phải sau ngày bắt đầu';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Switch Active
                                  SwitchListTile(
                                    title: const Text('Đặt làm năm học hiện tại?'),
                                    subtitle: const Text('Các năm học khác sẽ bị hủy kích hoạt.'),
                                    value: _isActive,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isActive = value;
                                      });
                                    },
                                    secondary: Icon(
                                      _isActive ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: _isActive ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                  // --- KẾT THÚC CẬP NHẬT ---

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