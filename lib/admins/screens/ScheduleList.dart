import 'package:flutter/material.dart';
import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/Schedule.dart';
import '../services/ScheduleService.dart';
import 'ScheduleCreate.dart';
import 'ScheduleEdit.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final String _currentPage = 'Schedule'; // Đặt tên page để highlight sidebar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                TopBar(title: 'Thời khóa biểu', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: ScheduleTableCard(),
                  ),
                ),
                AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleTableCard extends StatefulWidget {
  const ScheduleTableCard({Key? key}) : super(key: key);

  @override
  State<ScheduleTableCard> createState() => _ScheduleTableCardState();
}

class _ScheduleTableCardState extends State<ScheduleTableCard> {
  final ScheduleService _scheduleService = ScheduleService();

  List<Schedule> _scheduleList = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({int page = 1}) async {
    setState(() => _isLoading = true);
    try {
      var result = await _scheduleService.fetchSchedules(page: page);
      setState(() {
        _scheduleList = result['schedules'];
        _currentPage = result['current_page'];
        _lastPage = result['last_page'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Lỗi khi tải dữ liệu: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _lastPage) {
      _fetchData(page: page);
    }
  }

  // Hàm helper chuyển 1-7 sang Thứ
  String _getDayOfWeek(int day) {
    switch (day) {
      case 1: return 'Thứ 2';
      case 2: return 'Thứ 3';
      case 3: return 'Thứ 4';
      case 4: return 'Thứ 5';
      case 5: return 'Thứ 6';
      case 6: return 'Thứ 7';
      case 7: return 'Chủ Nhật';
      default: return 'N/A';
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.white,
      elevation: 3.0,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thời khóa biểu',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScheduleCreate()),
                    ).then((_) => _fetchData(page: 1));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              // ... (Search widget) ...
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
                : _scheduleList.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Không có dữ liệu thời khóa biểu.'),
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: constraints.maxWidth),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Mã TKB')),
                            DataColumn(label: Text('Môn học')),
                            DataColumn(label: Text('Lớp SV')),
                            DataColumn(label: Text('Giảng viên')),
                            DataColumn(label: Text('Phòng')),
                            DataColumn(label: Text('Thứ')),
                            DataColumn(label: Text('Thời gian')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _scheduleList
                              .asMap()
                              .entries
                              .map((entry) => _buildDataRow(
                              entry.value, entry.key))
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // ... (Pagination) ...
              ],
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(Schedule schedule, int index) {

    final String subjectName = schedule.course?.subject?.name ?? 'N/A';
    final String className = schedule.course?.studentClass?.name ?? 'N/A';
    final String lecturerName = schedule.course?.lecturer?.fullName ?? 'N/A';
    final String roomName = schedule.room?.name ?? 'N/A';
    final String dayOfWeek = _getDayOfWeek(schedule.dayOfWeek);
    final String time = '${schedule.startTime} - ${schedule.endTime}';


    return DataRow(
      cells: [
        DataCell(Text(schedule.id.toString())),
        DataCell(Text(subjectName)),
        DataCell(Text(className)),
        DataCell(Text(lecturerName)),
        DataCell(Text(roomName)),
        DataCell(Text(dayOfWeek)),
        DataCell(Text(time)),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              tooltip: 'Chỉnh sửa',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScheduleEdit(schedule: schedule)),
                ).then((_) => _fetchData(page: _currentPage));
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon:
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              tooltip: 'Xóa',
              onPressed: () => _handleDelete(schedule.id),
            ),
          ],
        )),
      ],
    );
  }

  Future<void> _handleDelete(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa TKB này? MỌI BUỔI HỌC (kể cả đã điểm danh) sẽ bị xóa theo.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _scheduleService.deleteSchedule(id);
        _fetchData(page: _currentPage);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Xóa thời khóa biểu thành công!'),
                backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Lỗi khi xóa: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}