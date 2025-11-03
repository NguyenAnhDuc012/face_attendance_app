import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/StudyPeriod.dart'; // Model đợt học
import '../models/Semester.dart'; // Model học kỳ
import '../services/StudyPeriodService.dart';
import '../services/SemesterService.dart';
import '../screens/StudyPeriodList.dart';

class StudyPeriodEdit extends StatefulWidget {
  final StudyPeriod studyPeriod; // Đợt học cần sửa
  const StudyPeriodEdit({Key? key, required this.studyPeriod}) : super(key: key);

  @override
  State<StudyPeriodEdit> createState() => _StudyPeriodEditState();
}

class _StudyPeriodEditState extends State<StudyPeriodEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final StudyPeriodService _studyPeriodService = StudyPeriodService();
  final SemesterService _semesterService = SemesterService();
  bool _isLoading = false;

  List<Semester> _semesters = [];
  Semester? _selectedSemester;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studyPeriod.name);
    _loadSemesters();
  }

  Future<void> _loadSemesters() async {
    try {
      // Tải danh sách học kỳ
      var result = await _semesterService.fetchSemesters(page: 1);
      setState(() {
        _semesters = result['semesters'];
        // Tìm và chọn học kỳ hiện tại của đợt học này
        if (_semesters.isNotEmpty) {
          _selectedSemester = _semesters.firstWhere(
                (s) => s.id == widget.studyPeriod.semesterId,
            orElse: () => _semesters.first,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải danh sách học kỳ: $e'),
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
    if (!_formKey.currentState!.validate() || _selectedSemester == null) return;

    setState(() => _isLoading = true);

    try {
      await _studyPeriodService.updateStudyPeriod(
        id: widget.studyPeriod.id,
        name: _nameController.text,
        semesterId: _selectedSemester!.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật đợt học tập thành công!'),
            backgroundColor: Colors.green,
          ),
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
          const Sidebar(currentPage: 'StudyPeriod'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Đợt học tập', subtitle: 'Sửa'),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const StudyPeriodList(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sửa đợt học tập',
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
                                      .map(
                                        (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text('${s.name} (${s.academicYear?.startYear ?? ''} - ${s.academicYear?.endYear ?? ''})'),
                                    ),
                                  )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedSemester = val),
                                  decoration: const InputDecoration(
                                    labelText: 'Chọn học kỳ',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) => val == null
                                      ? 'Vui lòng chọn học kỳ'
                                      : null,
                                ),
                                const SizedBox(height: 40),

                                // Nút Cập nhật
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