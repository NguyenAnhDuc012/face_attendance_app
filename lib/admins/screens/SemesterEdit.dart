import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- 1. Thêm import
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Semester.dart'; // Model học kỳ
import '../models/AcademicYear.dart'; // Model năm học
import '../services/SemesterService.dart';
import '../services/AcademicYearService.dart';
import '../screens/SemesterList.dart';

class SemesterEdit extends StatefulWidget {
  final Semester semester; // Học kỳ cần sửa
  const SemesterEdit({Key? key, required this.semester}) : super(key: key);

  @override
  State<SemesterEdit> createState() => _SemesterEditState();
}

class _SemesterEditState extends State<SemesterEdit> {
  final _formKey = GlobalKey<FormState>();
  final SemesterService _semesterService = SemesterService();
  final AcademicYearService _academicYearService = AcademicYearService();
  bool _isLoading = false;

  // Controller
  late final TextEditingController _nameController;
  final _startDateController = TextEditingController(); // <-- MỚI
  final _endDateController = TextEditingController();   // <-- MỚI

  // State
  List<AcademicYear> _academicYears = [];
  AcademicYear? _selectedAcademicYear;
  DateTime? _selectedStartDate; // <-- MỚI
  DateTime? _selectedEndDate;   // <-- MỚI
  late bool _isActive;          // <-- MỚI

  // --- 2. Thêm các hàm helper cho ngày ---
  String _formatDateForDisplay(String? serviceDate) {
    if (serviceDate == null || serviceDate.isEmpty) return '';
    try {
      DateTime date = DateTime.parse(serviceDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) { return ''; }
  }
  String? _formatDateForService(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }
  // ------------------------------------

  @override
  void initState() {
    super.initState();
    // --- 3. Cập nhật initState ---
    _nameController = TextEditingController(text: widget.semester.name);
    _isActive = widget.semester.isActive; // Lấy giá trị active

    // Khởi tạo ngày
    if (widget.semester.startDate != null) {
      _selectedStartDate = DateTime.parse(widget.semester.startDate!);
      _startDateController.text = _formatDateForDisplay(widget.semester.startDate);
    }
    if (widget.semester.endDate != null) {
      _selectedEndDate = DateTime.parse(widget.semester.endDate!);
      _endDateController.text = _formatDateForDisplay(widget.semester.endDate);
    }
    // ----------------------------

    _loadAcademicYears();
  }

  Future<void> _loadAcademicYears() async {
    try {
      // Tải danh sách năm học
      var result = await _academicYearService.fetchAcademicYears(page: 1);
      setState(() {
        _academicYears = result['academicYears'];
        // Tìm và chọn năm học hiện tại của học kỳ này
        if (_academicYears.isNotEmpty) {
          _selectedAcademicYear = _academicYears.firstWhere(
                (f) => f.id == widget.semester.academicYearId,
            orElse: () => _academicYears.first,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải năm học: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose(); // <-- MỚI
    _endDateController.dispose();   // <-- MỚI
    super.dispose();
  }

  // --- 4. Thêm helper chọn ngày ---
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initial = isStartDate
        ? (_selectedStartDate ?? DateTime.now())
        : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context, initialDate: initial,
      firstDate: DateTime(2000), lastDate: DateTime(2101),
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          _startDateController.text = formattedDate;
        } else {
          _selectedEndDate = picked;
          _endDateController.text = formattedDate;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedAcademicYear == null) return;

    setState(() => _isLoading = true);

    try {
      // --- 5. Cập nhật hàm gọi service ---
      await _semesterService.updateSemester(
        id: widget.semester.id,
        name: _nameController.text,
        academicYearId: _selectedAcademicYear!.id,
        // Thêm các trường mới
        startDate: _formatDateForService(_selectedStartDate),
        endDate: _formatDateForService(_selectedEndDate),
        isActive: _isActive,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật học kỳ thành công!'),
            backgroundColor: Colors.green,
          ),
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
            content: Text('Lỗi khi cập nhật học kỳ: $errorMessage'),
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
          const Sidebar(currentPage: 'Semester'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Học kỳ', subtitle: 'Sửa'),
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
                            // --- 6. Thêm SingleChildScrollView ---
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
                                            const SemesterList(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Sửa học kỳ',
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
                                        .map(
                                          (f) => DropdownMenuItem(
                                        value: f,
                                        child: Text('${f.startYear} - ${f.endYear} ${f.isActive ? '(Hiện tại)' : ''}'),
                                      ),
                                    )
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedAcademicYear = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn năm học',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) => val == null
                                        ? 'Vui lòng chọn năm học'
                                        : null,
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

                                  // --- 7. Thêm các trường mới vào Form ---
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