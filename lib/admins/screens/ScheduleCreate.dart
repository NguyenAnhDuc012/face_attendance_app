import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
// Import các model và service cần thiết
import '../models/Course.dart';
import '../services/CourseService.dart';
import '../models/Room.dart';
import '../services/RoomService.dart';
import '../services/ScheduleService.dart';
import '../screens/ScheduleList.dart';

class ScheduleCreate extends StatefulWidget {
  const ScheduleCreate({Key? key}) : super(key: key);

  @override
  State<ScheduleCreate> createState() => _ScheduleCreateState();
}

class _ScheduleCreateState extends State<ScheduleCreate> {
  final _formKey = GlobalKey<FormState>();

  // Services
  final ScheduleService _scheduleService = ScheduleService();
  final CourseService _courseService = CourseService();
  final RoomService _roomService = RoomService();

  bool _isLoading = false;
  bool _isLoadingDependencies = false;

  // Danh sách cho dropdown
  List<Course> _courses = [];
  List<Room> _rooms = [];

  // Dữ liệu cho Dropdown "Thứ"
  // 1 = Thứ 2, 7 = Chủ Nhật
  final List<Map<String, dynamic>> _daysOfWeek = [
    {'value': 1, 'text': 'Thứ 2'},
    {'value': 2, 'text': 'Thứ 3'},
    {'value': 3, 'text': 'Thứ 4'},
    {'value': 4, 'text': 'Thứ 5'},
    {'value': 5, 'text': 'Thứ 6'},
    {'value': 6, 'text': 'Thứ 7'},
    {'value': 7, 'text': 'Chủ Nhật'},
  ];

  // Giá trị đã chọn
  Course? _selectedCourse;
  Room? _selectedRoom;
  int? _selectedDayOfWeek;

  // Controller cho TimePicker
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;


  @override
  void initState() {
    super.initState();
    _loadDependencies();
    _selectedDayOfWeek = _daysOfWeek.first['value']; // Chọn Thứ 2 làm mặc định
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  // Tải dữ liệu cho 2 dropdown
  Future<void> _loadDependencies() async {
    setState(() => _isLoadingDependencies = true);
    try {
      final results = await Future.wait([
        _courseService.fetchCourses(page: 1),
        _roomService.fetchRooms(page: 1),
      ]);

      setState(() {
        _courses = results[0]['courses'];
        if (_courses.isNotEmpty) _selectedCourse = _courses.first;

        _rooms = results[1]['rooms'];
        if (_rooms.isNotEmpty) _selectedRoom = _rooms.first;
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

  // Hàm helper chọn thời gian
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_selectedStartTime ?? TimeOfDay(hour: 7, minute: 0))
          : (_selectedEndTime ?? _selectedStartTime ?? TimeOfDay(hour: 9, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = picked;
          _startTimeController.text = picked.format(context);
        } else {
          _selectedEndTime = picked;
          _endTimeController.text = picked.format(context);
        }
      });
    }
  }

  // Hàm helper chuyển TimeOfDay (1:30 PM) sang chuỗi "HH:mm" (13:30)
  String _formatTimeForService(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _selectedCourse == null ||
        _selectedRoom == null ||
        _selectedDayOfWeek == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null
    )
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
      await _scheduleService.createSchedule(
          courseId: _selectedCourse!.id,
          roomId: _selectedRoom!.id,
          dayOfWeek: _selectedDayOfWeek!,
          startTime: _formatTimeForService(_selectedStartTime!), // Format sang "HH:mm"
          endTime: _formatTimeForService(_selectedEndTime!)   // Format sang "HH:mm"
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tạo TKB và các buổi học thành công!'),
              backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScheduleList()),
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
          const Sidebar(currentPage: 'Schedule'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Thời khóa biểu', subtitle: 'Thêm mới'),
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
                                              const ScheduleList()),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Quay lại'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Thêm Thời khóa biểu',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),

                                  // Dropdown Lớp học phần (Course)
                                  DropdownButtonFormField<Course>(
                                    value: _selectedCourse,
                                    items: _courses
                                        .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text('${c.subject?.name ?? 'N/A'} - ${c.studentClass?.name ?? 'N/A'}'),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedCourse = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn lớp học phần',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) =>
                                    val == null ? 'Vui lòng chọn lớp học phần' : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Dropdown Phòng học (Room)
                                  DropdownButtonFormField<Room>(
                                    value: _selectedRoom,
                                    items: _rooms
                                        .map((r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(r.name),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedRoom = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn phòng học',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (val) =>
                                    val == null ? 'Vui lòng chọn phòng học' : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Dropdown Thứ (Day of Week)
                                  DropdownButtonFormField<int>(
                                    value: _selectedDayOfWeek,
                                    items: _daysOfWeek
                                        .map((day) => DropdownMenuItem(
                                      value: day['value'] as int,
                                      child: Text(day['text'] as String),
                                    ))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedDayOfWeek = val),
                                    decoration: const InputDecoration(
                                      labelText: 'Chọn thứ trong tuần',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Time Picker Giờ Bắt đầu
                                  TextFormField(
                                    controller: _startTimeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Giờ bắt đầu',
                                      prefixIcon: Icon(Icons.access_time),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: true,
                                    onTap: () => _selectTime(context, true),
                                    validator: (val) => (val == null || val.isEmpty) ? 'Vui lòng chọn giờ bắt đầu' : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Time Picker Giờ Kết thúc
                                  TextFormField(
                                    controller: _endTimeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Giờ kết thúc',
                                      prefixIcon: Icon(Icons.access_time_filled),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: true,
                                    onTap: () => _selectTime(context, false),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) return 'Vui lòng chọn giờ kết thúc';
                                      if (_selectedStartTime != null && _selectedEndTime != null) {
                                        double startTime = _selectedStartTime!.hour + _selectedStartTime!.minute / 60.0;
                                        double endTime = _selectedEndTime!.hour + _selectedEndTime!.minute / 60.0;
                                        if (endTime <= startTime) {
                                          return 'Giờ kết thúc phải sau giờ bắt đầu';
                                        }
                                      }
                                      return null;
                                    },
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