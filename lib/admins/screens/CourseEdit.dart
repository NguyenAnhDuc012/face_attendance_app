import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Course.dart';
import '../services/CourseService.dart';
import '../models/Subject.dart';
import '../services/SubjectService.dart';
import '../models/StudentClass.dart';
import '../services/StudentClassService.dart';
import '../models/StudyPeriod.dart';
import '../services/StudyPeriodService.dart';
import '../models/Lecturer.dart';
import '../services/LecturerService.dart';

import '../screens/CourseList.dart';

class CourseEdit extends StatefulWidget {
  final Course course;
  const CourseEdit({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseEdit> createState() => _CourseEditState();
}

class _CourseEditState extends State<CourseEdit> {
  final _formKey = GlobalKey<FormState>();

  // Khởi tạo tất cả service
  final CourseService _courseService = CourseService();
  final SubjectService _subjectService = SubjectService();
  final StudentClassService _classService = StudentClassService();
  final StudyPeriodService _periodService = StudyPeriodService();
  final LecturerService _lecturerService = LecturerService();

  bool _isLoading = false; // Trạng thái tải chung
  bool _isLoadingDependencies = false; // Trạng thái tải dropdown

  // Danh sách cho dropdown
  List<Subject> _subjects = [];
  List<StudentClass> _studentClasses = [];
  List<StudyPeriod> _studyPeriods = [];
  List<Lecturer> _lecturers = [];

  // Giá trị đã chọn
  Subject? _selectedSubject;
  StudentClass? _selectedClass;
  StudyPeriod? _selectedPeriod;
  Lecturer? _selectedLecturer;

  @override
  void initState() {
    super.initState();
    _loadDependencies();
  }

  // Tải song song tất cả dữ liệu cho 4 dropdown và set giá trị cũ
  Future<void> _loadDependencies() async {
    setState(() => _isLoadingDependencies = true);
    try {
      // Tải trang 1 của tất cả
      final results = await Future.wait([
        _subjectService.fetchSubjects(page: 1),
        _classService.fetchStudentClasses(page: 1),
        _periodService.fetchStudyPeriods(page: 1),
        _lecturerService.fetchLecturers(page: 1),
      ]);

      setState(() {
        // Tải Subject
        _subjects = results[0]['subjects'];
        if (_subjects.isNotEmpty) {
          _selectedSubject = _subjects.firstWhere(
                (s) => s.id == widget.course.subjectId,
            orElse: () => _subjects.first,
          );
        }

        // Tải StudentClass
        _studentClasses = results[1]['studentClasses'];
        if (_studentClasses.isNotEmpty) {
          _selectedClass = _studentClasses.firstWhere(
                (c) => c.id == widget.course.classId,
            orElse: () => _studentClasses.first,
          );
        }

        // Tải StudyPeriod
        _studyPeriods = results[2]['studyPeriods'];
        if (_studyPeriods.isNotEmpty) {
          _selectedPeriod = _studyPeriods.firstWhere(
                (p) => p.id == widget.course.studyPeriodId,
            orElse: () => _studyPeriods.first,
          );
        }

        // Tải Lecturer
        _lecturers = results[3]['lecturers'];
        if (_lecturers.isNotEmpty) {
          _selectedLecturer = _lecturers.firstWhere(
                (l) => l.id == widget.course.lecturerId,
            orElse: () => _lecturers.first,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi khi tải dữ liệu dropdown: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingDependencies = false);
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _selectedSubject == null ||
        _selectedClass == null ||
        _selectedPeriod == null ||
        _selectedLecturer == null)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng chọn đầy đủ thông tin'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _courseService.updateCourse(
          id: widget.course.id, // ID của course cần update
          subjectId: _selectedSubject!.id,
          classId: _selectedClass!.id,
          studyPeriodId: _selectedPeriod!.id,
          lecturerId: _selectedLecturer!.id
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Cập nhật lớp học phần thành công!'),
              backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CourseList()),
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
          const Sidebar(currentPage: 'Course'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Lớp học phần', subtitle: 'Sửa'),
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
                          child: _isLoadingDependencies
                              ? const Center(child: CircularProgressIndicator())
                              : Form(
                            key: _formKey,
                            child: SingleChildScrollView(
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
                                              const CourseList()),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Sửa lớp học phần',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),

                                  // Dropdown Môn học
                                  DropdownButtonFormField<Subject>(
                                    value: _selectedSubject,
                                    items: _subjects
                                        .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s.name),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedSubject = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn môn học',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) =>
                                    val == null ? 'Vui lòng chọn môn học' : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Dropdown Lớp sinh viên
                                  DropdownButtonFormField<StudentClass>(
                                    value: _selectedClass,
                                    items: _studentClasses
                                        .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c.name),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedClass = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn lớp sinh viên',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) =>
                                    val == null ? 'Vui lòng chọn lớp' : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Dropdown Đợt học
                                  DropdownButtonFormField<StudyPeriod>(
                                    value: _selectedPeriod,
                                    items: _studyPeriods
                                        .map((p) => DropdownMenuItem(
                                      value: p,
                                      child: Text('${p.name} - ${p.semester?.name ?? ''}'),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedPeriod = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn đợt học',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) =>
                                    val == null ? 'Vui lòng chọn đợt học' : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Dropdown Giảng viên
                                  DropdownButtonFormField<Lecturer>(
                                    value: _selectedLecturer,
                                    items: _lecturers
                                        .map((l) => DropdownMenuItem(
                                      value: l,
                                      child: Text(l.fullName),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedLecturer = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn giảng viên',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) =>
                                    val == null ? 'Vui lòng chọn giảng viên' : null,
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
                                        : const Text('Cập nhật',
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