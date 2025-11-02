import 'package:flutter/material.dart';
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
        if (_academicYears.isNotEmpty) _selectedAcademicYear = _academicYears.first;
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
    // TODO: Cân nhắc tải tất cả năm học nếu danh sách quá dài
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedAcademicYear == null) return;

    setState(() => _isLoading = true);

    try {
      await _semesterService.createSemester(
          name: _nameController.text,
          academicYearId: _selectedAcademicYear!.id);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi khi tạo học kỳ: $e'),
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
                                DropdownButtonFormField<AcademicYear>(
                                  value: _selectedAcademicYear,
                                  items: _academicYears
                                      .map((f) => DropdownMenuItem(
                                    value: f,
                                    child: Text('${f.startYear} - ${f.endYear}'),
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
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}