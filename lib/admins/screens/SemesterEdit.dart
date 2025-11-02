import 'package:flutter/material.dart';
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
  late final TextEditingController _nameController;
  final SemesterService _semesterService = SemesterService();
  final AcademicYearService _academicYearService = AcademicYearService();
  bool _isLoading = false;

  List<AcademicYear> _academicYears = [];
  AcademicYear? _selectedAcademicYear;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.semester.name);
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
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedAcademicYear == null) return;

    setState(() => _isLoading = true);

    try {
      await _semesterService.updateSemester(
        id: widget.semester.id,
        name: _nameController.text,
        academicYearId: _selectedAcademicYear!.id,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi cập nhật học kỳ: $e'),
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
                                      .map(
                                        (f) => DropdownMenuItem(
                                      value: f,
                                      child: Text('${f.startYear} - ${f.endYear}'),
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