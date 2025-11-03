import 'package:flutter/material.dart';
import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/Lecturer.dart';
import '../services/LecturerService.dart';
import 'LecturerCreate.dart';
import 'LecturerEdit.dart';

class LecturerList extends StatefulWidget {
  const LecturerList({Key? key}) : super(key: key);

  @override
  State<LecturerList> createState() => _LecturerListState();
}

class _LecturerListState extends State<LecturerList> {
  final String _currentPage = 'Lecturer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                TopBar(title: 'Giảng viên', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: LecturerTableCard(),
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

class LecturerTableCard extends StatefulWidget {
  const LecturerTableCard({Key? key}) : super(key: key);

  @override
  State<LecturerTableCard> createState() => _LecturerTableCardState();
}

class _LecturerTableCardState extends State<LecturerTableCard> {
  final LecturerService _lecturerService = LecturerService();

  List<Lecturer> _lecturerList = [];
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
      var result = await _lecturerService.fetchLecturers(page: page);
      setState(() {
        _lecturerList = result['lecturers'];
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
            // Header + Button thêm mới
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giảng viên',
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
                          builder: (context) => const LecturerCreate()),
                    ).then((_) => _fetchData(page: 1));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search (Tạm thời vô hiệu hóa)
            Align(
              // ... (Code Search) ...
            ),
            const SizedBox(height: 24),

            // Bảng dữ liệu
            _isLoading
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
                : _lecturerList.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Không có dữ liệu giảng viên.'),
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
                          horizontalMargin: 24.0,
                          columnSpacing: 32.0,
                          // ... (Code style DataTable) ...
                          columns: const [
                            DataColumn(label: Text('Mã')),
                            DataColumn(label: Text('Họ tên')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('SĐT')),
                            DataColumn(label: Text('Khoa')),
                            DataColumn(label: Text('Cơ sở')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _lecturerList
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

                // Pagination controls
                Container(
                  // ... (Code Pagination) ...
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(Lecturer lecturer, int index) {
    final Color rowColor = index.isEven ? Colors.white : Colors.grey[50]!;

    final String facultyName = lecturer.faculty?.name ?? 'N/A';
    final String facilityName = lecturer.faculty?.facility?.name ?? 'N/A';

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(lecturer.id.toString())),
        DataCell(Text(lecturer.fullName)),
        DataCell(Text(lecturer.email)),
        DataCell(Text(lecturer.phone ?? 'N/A')),
        DataCell(Text(facultyName)), // Hiển thị tên khoa
        DataCell(Text(facilityName)), // Hiển thị tên cơ sở
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
                          LecturerEdit(lecturer: lecturer)),
                ).then((_) => _fetchData(page: _currentPage));
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon:
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              tooltip: 'Xóa',
              onPressed: () => _handleDelete(lecturer.id),
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
        content: const Text('Bạn có chắc chắn muốn xóa giảng viên này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _lecturerService.deleteLecturer(id);
        _fetchData(page: _currentPage);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa giảng viên thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}