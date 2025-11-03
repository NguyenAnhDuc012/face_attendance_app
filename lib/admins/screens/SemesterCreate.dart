import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- 1. Thêm import
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../services/SemesterService.dart';
import '../services/AcademicYearService.dart'; // Service của năm học
import '../models/AcademicYear.dart'; // Model của năm học
import '../screens/SemesterList.dart';

class SemesterCreate extends StatefulWidget {
  const SemesterCreate({Key? key}) : super(key: key);

  @override
  State<SemesterCreate> createState() => _SemesterCreateState();
}

class _SemesterCreateState extends State<SemesterCreate> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final SemesterService _semesterService = SemesterService();
  final AcademicYearService _academicYearService =
  AcademicYearService(); // Service năm học
  bool _isLoading = false;
  AcademicYear? _selectedAcademicYear; // Năm học được chọn
  List<AcademicYear> _academicYears = []; // Danh sách năm học

  // --- 2. Thêm state cho các trường mới ---
  final _startDateController = TextEditingController(); // Chỉ để hiển thị
  final _endDateController = TextEditingController();   // Chỉ để hiển thị
  DateTime? _selectedStartDate; // Dùng để gửi đi
  DateTime? _selectedEndDate;   // Dùng để gửi đi
  bool _isActive = false;      // Dùng cho Switch
  // ------------------------------------

  @override
  void initState() {
    super.initState();
    _loadAcademicYears();
  }

  Future<void> _loadAcademicYears() async {
    try {
      // Tải trang đầu tiên của danh sách năm học để hiển thị trong dropdown
      var result = await _academicYearService.fetchAcademicYears(page: 1);
      setState(() {
        _academicYears = result['academicYears'];
        if (_academicYears.isNotEmpty) {
          // Tự động chọn năm học đang active
          _selectedAcademicYear = _academicYears.firstWhere(
                  (y) => y.isActive,
              orElse: () => _academicYears.first
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi khi tải năm học: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose(); // <-- Thêm
    _endDateController.dispose();   // <-- Thêm
    super.dispose();
  }

  // --- 3. Thêm các hàm helper cho ngày ---
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initial = isStartDate
        ? (_selectedStartDate ?? DateTime.now())
        : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context, initialDate: initial,
      firstDate: DateTime(2000), lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Hiển thị dd/MM/yyyy
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked; // Lưu DateTime
          _startDateController.text = formattedDate; // Hiển thị
        } else {
          _selectedEndDate = picked; // Lưu DateTime
          _endDateController.text = formattedDate; // Hiển thị
        }
      });
    }
  }

  // Chuyển DateTime sang yyyy-MM-dd để gửi đi
  String? _formatDateForService(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }
  // ------------------------------------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedAcademicYear == null) return;

    setState(() => _isLoading = true);

    try {
      // --- 4. Cập nhật hàm gọi service ---
      await _semesterService.createSemester(
          name: _nameController.text,
          academicYearId: _selectedAcademicYear!.id,
          // Thêm các trường mới
          startDate: _formatDateForService(_selectedStartDate),
          endDate: _formatDateForService(_selectedEndDate),
          isActive: _isActive
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tạo học kỳ thành công!'),
              backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SemesterList()),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst("Exception: ", "");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi khi tạo học kỳ: $errorMessage'),
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
          const Sidebar(currentPage: 'Semester'), // Highlight mục 'Semester'
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Học kỳ', subtitle: 'Thêm mới'),
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
                            // --- 5. Thêm SingleChildScrollView ---
                            child: SingleChildScrollView(
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
                                              const SemesterList()),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Thêm học kỳ mới',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),

                                  // Dropdown Năm học
                                  DropdownButtonFormField<AcademicYear>(
                                    value: _selectedAcademicYear,
                                    items: _academicYears
                                        .map((f) => DropdownMenuItem(
                                      value: f,
                                      // Hiển thị (Hiện tại) nếu active
                                      child: Text('${f.startYear} - ${f.endYear} ${f.isActive ? '(Hiện tại)' : ''}'),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedAcademicYear = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn năm học',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) =>
                                    val == null ? 'Vui lòng chọn năm học' : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Tên học kỳ
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Tên học kỳ',
                                      prefixIcon: Icon(Icons.school_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Vui lòng nhập tên học kỳ'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // --- 6. Thêm các trường mới vào Form ---
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
                                  const SizedBox(height: 16),

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
                                  const SizedBox(height: 16),

                                  // Switch Active
                                  SwitchListTile(
                                    title: const Text('Đặt làm học kỳ hiện tại?'),
                                    subtitle: const Text('Học kỳ này sẽ được kích hoạt (trong năm học đã chọn).'),
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
                                  // --- Hết trường mới ---

                                  const SizedBox(height: 40),
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