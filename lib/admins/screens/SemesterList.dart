import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- 1. Thêm import
import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/Semester.dart';
import '../services/SemesterService.dart';
import 'SemesterCreate.dart';
import 'SemesterEdit.dart';

class SemesterList extends StatefulWidget {
  const SemesterList({Key? key}) : super(key: key);

  @override
  State<SemesterList> createState() => _SemesterListState();
}

class _SemesterListState extends State<SemesterList> {
  final String _currentPage = 'Semester';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                TopBar(title: 'Học kỳ', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: SemesterTableCard(),
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

class SemesterTableCard extends StatefulWidget {
  const SemesterTableCard({Key? key}) : super(key: key);

  @override
  State<SemesterTableCard> createState() => _SemesterTableCardState();
}

class _SemesterTableCardState extends State<SemesterTableCard> {
  final SemesterService _semesterService = SemesterService();

  List<Semester> _semesterList = [];
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
      var result = await _semesterService.fetchSemesters(page: page);
      setState(() {
        _semesterList = result['semesters'];
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

  // --- 2. Thêm hàm helper định dạng ngày ---
  /// Định dạng chuỗi ngày YYYY-MM-DD sang DD/MM/YYYY
  String _formatDateForDisplay(String? serviceDate) {
    if (serviceDate == null || serviceDate.isEmpty) return 'N/A';
    try {
      // Parse chuỗi từ server
      DateTime date = DateTime.parse(serviceDate);
      // Định dạng lại để hiển thị
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Lỗi Ngày'; // Trả về nếu định dạng không đúng
    }
  }
  // ------------------------------------

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
                  'Học kỳ',
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
                          builder: (context) => const SemesterCreate()),
                    ).then((_) => _fetchData(page: 1));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 320,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon:
                    const Icon(Icons.search, size: 20, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    // TODO: Xử lý logic search
                  },
                ),
              ),
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
                : _semesterList.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Không có dữ liệu học kỳ.'),
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
                          headingRowColor:
                          MaterialStateProperty.all(
                              Colors.grey[100]),
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          border: TableBorder.all(
                            color: Colors.grey[300]!,
                            width: 1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // --- 3. Cập nhật cột ---
                          columns: const [
                            DataColumn(label: Text('Mã')),
                            DataColumn(label: Text('Tên học kỳ')),
                            DataColumn(label: Text('Năm học')),
                            DataColumn(label: Text('Ngày BĐ')), // <-- MỚI
                            DataColumn(label: Text('Ngày KT')), // <-- MỚI
                            DataColumn(label: Text('Trạng thái')), // <-- MỚI
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _semesterList
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
                  padding: const EdgeInsets.only(top: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 16),
                        onPressed: _currentPage > 1
                            ? () => _goToPage(_currentPage - 1)
                            : null,
                      ),
                      Text('Trang $_currentPage / $_lastPage',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            size: 16),
                        onPressed: _currentPage < _lastPage
                            ? () => _goToPage(_currentPage + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. Cập nhật hàng ---
  DataRow _buildDataRow(Semester semester, int index) {
    final Color rowColor = index.isEven ? Colors.white : Colors.grey[50]!;

    // Hiển thị năm học (ví dụ: "2023 - 2024")
    final String academicYearText = semester.academicYear != null
        ? '${semester.academicYear!.startYear} - ${semester.academicYear!.endYear}'
        : 'N/A';

    // Định dạng ngày
    final String startDate = _formatDateForDisplay(semester.startDate);
    final String endDate = _formatDateForDisplay(semester.endDate);

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(semester.id.toString())),
        DataCell(Text(semester.name)),
        DataCell(Text(academicYearText)),
        DataCell(Text(startDate)), // <-- MỚI
        DataCell(Text(endDate)),   // <-- MỚI
        // Trạng thái
        DataCell( // <-- MỚI
          Chip(
            label: Text(
              semester.isActive ? 'Hoạt động' : 'Không',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: semester.isActive ? Colors.green : Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            labelStyle: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              tooltip: 'Chỉnh sửa',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SemesterEdit(semester: semester)),
                ).then((_) => _fetchData(page: _currentPage));
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon:
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              tooltip: 'Xóa',
              onPressed: () => _handleDelete(semester.id),
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
        content: const Text('Bạn có chắc chắn muốn xóa học kỳ này?'),
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
        await _semesterService.deleteSemester(id);
        _fetchData(page: _currentPage); // Tải lại trang hiện tại
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Xóa học kỳ thành công!'),
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