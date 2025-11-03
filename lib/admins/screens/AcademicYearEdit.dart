import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/AcademicYear.dart';
import '../services/AcademicYearService.dart';
import 'AcademicYearList.dart';
import 'package:intl/intl.dart';

class AcademicYearEdit extends StatefulWidget {
  final AcademicYear item;
  const AcademicYearEdit({Key? key, required this.item}) : super(key: key);

  @override
  State<AcademicYearEdit> createState() => _AcademicYearEditState();
}

class _AcademicYearEditState extends State<AcademicYearEdit> {
  final _formKey = GlobalKey<FormState>();
  final AcademicYearService _service = AcademicYearService();
  bool _isLoading = false;

  // Controller
  late final TextEditingController _startYearController;
  late final TextEditingController _endYearController;
  final _startDateController = TextEditingController(); // Chỉ hiển thị
  final _endDateController = TextEditingController();   // Chỉ hiển thị

  // State
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  late bool _isActive;

  // --- HÀM HELPER ---
  // Định dạng YYYY-MM-DD (từ server) sang DD/MM/YYYY (hiển thị)
  String _formatDateForDisplay(String? serviceDate) {
    if (serviceDate == null || serviceDate.isEmpty) return '';
    try {
      DateTime date = DateTime.parse(serviceDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return ''; // Trả về rỗng nếu parse lỗi
    }
  }

  // Định dạng DateTime sang YYYY-MM-DD (gửi đi)
  String? _formatDateForService(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  void initState() {
    super.initState();
    // Gán giá trị ban đầu
    _startYearController = TextEditingController(text: widget.item.startYear.toString());
    _endYearController = TextEditingController(text: widget.item.endYear.toString());
    _isActive = widget.item.isActive;

    // Cập nhật state ngày và controller hiển thị
    if (widget.item.startDate != null) {
      _selectedStartDate = DateTime.parse(widget.item.startDate!);
      _startDateController.text = _formatDateForDisplay(widget.item.startDate);
    }
    if (widget.item.endDate != null) {
      _selectedEndDate = DateTime.parse(widget.item.endDate!);
      _endDateController.text = _formatDateForDisplay(widget.item.endDate);
    }
  }

  @override
  void dispose() {
    _startYearController.dispose();
    _endYearController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // Hàm helper để chọn ngày
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
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked); // Hiển thị
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked; // Lưu
          _startDateController.text = formattedDate;
        } else {
          _selectedEndDate = picked; // Lưu
          _endDateController.text = formattedDate;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _service.updateAcademicYear(
        id: widget.item.id,
        startYear: int.parse(_startYearController.text),
        endYear: int.parse(_endYearController.text),

        // Gửi ngày đã định dạng
        startDate: _formatDateForService(_selectedStartDate), // <-- CẬP NHẬT
        endDate: _formatDateForService(_selectedEndDate),     // <-- CẬP NHẬT
        isActive: _isActive,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật năm học thành công!'),
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
          content: Text('Lỗi khi cập nhật năm học: $errorMessage'),
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
                const TopBar(title: 'Năm học', subtitle: 'Sửa'),
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
                                              const AcademicYearList()),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Sửa năm học',
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
                                      prefixIcon: Icon(Icons.calendar_today_outlined),
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
                                      prefixIcon: Icon(Icons.calendar_month_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập năm kết thúc';
                                      }
                                      final endYear = int.tryParse(value);
                                      final startYear =
                                      int.tryParse(_startYearController.text);
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
                                    controller: _startDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Ngày bắt đầu (Tùy chọn)',
                                      hintText: 'dd/mm/yyyy',
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: true,
                                    onTap: () => _selectDate(context, true),
                                  ),
                                  const SizedBox(height: 20),

                                  // Ngày KT
                                  TextFormField(
                                    controller: _endDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Ngày kết thúc (Tùy chọn)',
                                      hintText: 'dd/mm/yyyy',
                                      prefixIcon: Icon(Icons.date_range_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: true,
                                    onTap: () => _selectDate(context, false),
                                    validator: (value) {
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
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 16.0),
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