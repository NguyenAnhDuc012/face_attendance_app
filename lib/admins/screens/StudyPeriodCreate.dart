import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../services/StudyPeriodService.dart';
import '../services/SemesterService.dart'; // Service của Học kỳ
import '../models/Semester.dart'; // Model của Học kỳ
import '../screens/StudyPeriodList.dart';

class StudyPeriodCreate extends StatefulWidget {
  const StudyPeriodCreate({Key? key}) : super(key: key);

  @override
  State<StudyPeriodCreate> createState() => _StudyPeriodCreateState();
}

class _StudyPeriodCreateState extends State<StudyPeriodCreate> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final StudyPeriodService _studyPeriodService = StudyPeriodService();
  final SemesterService _semesterService = SemesterService(); // Service Học kỳ
  bool _isLoading = false;
  Semester? _selectedSemester; // Học kỳ được chọn
  List<Semester> _semesters = []; // Danh sách học kỳ

  @override
  void initState() {
    super.initState();
    _loadSemesters();
  }

  Future<void> _loadSemesters() async {
    try {
      // Tải trang đầu tiên của danh sách học kỳ
      var result = await _semesterService.fetchSemesters(page: 1);
      setState(() {
        _semesters = result['semesters'];
        if (_semesters.isNotEmpty) _selectedSemester = _semesters.first;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi khi tải học kỳ: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
    // TODO: Cân nhắc tải tất cả học kỳ nếu danh sách quá dài
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedSemester == null) return;

    setState(() => _isLoading = true);

    try {
      await _studyPeriodService.createStudyPeriod(
          name: _nameController.text,
          semesterId: _selectedSemester!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tạo đợt học tập thành công!'),
              backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudyPeriodList()),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst("Exception: ", "");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(errorMessage),
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
          const Sidebar(currentPage: 'StudyPeriod'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Đợt học tập', subtitle: 'Thêm mới'),
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
                                            const StudyPeriodList()),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Thêm đợt học tập mới',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),

                                // Tên đợt
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tên đợt học tập',
                                    prefixIcon: Icon(Icons.calendar_today_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Vui lòng nhập tên đợt'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Dropdown chọn Học kỳ
                                DropdownButtonFormField<Semester>(
                                  value: _selectedSemester,
                                  items: _semesters
                                      .map((s) => DropdownMenuItem(
                                    value: s,
                                    // Hiển thị: "Học kỳ 1 (2023 - 2024)"
                                    child: Text('${s.name} (${s.academicYear?.startYear ?? ''} - ${s.academicYear?.endYear ?? ''})'),
                                  ))
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedSemester = val),
                                  decoration: const InputDecoration(
                                    labelText: 'Chọn học kỳ',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) =>
                                  val == null ? 'Vui lòng chọn học kỳ' : null,
                                ),
                                const SizedBox(height: 40),

                                // Nút Submit
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