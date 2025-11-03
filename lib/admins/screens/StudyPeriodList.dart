import 'package:flutter/material.dart';
import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/StudyPeriod.dart';
import '../services/StudyPeriodService.dart';
import 'StudyPeriodCreate.dart';
import 'StudyPeriodEdit.dart';

class StudyPeriodList extends StatefulWidget {
  const StudyPeriodList({Key? key}) : super(key: key);

  @override
  State<StudyPeriodList> createState() => _StudyPeriodListState();
}

class _StudyPeriodListState extends State<StudyPeriodList> {
  final String _currentPage = 'StudyPeriod';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                TopBar(title: 'Đợt học tập', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: StudyPeriodTableCard(),
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

class StudyPeriodTableCard extends StatefulWidget {
  const StudyPeriodTableCard({Key? key}) : super(key: key);

  @override
  State<StudyPeriodTableCard> createState() => _StudyPeriodTableCardState();
}

class _StudyPeriodTableCardState extends State<StudyPeriodTableCard> {
  final StudyPeriodService _studyPeriodService = StudyPeriodService();

  List<StudyPeriod> _studyPeriodList = [];
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
      var result = await _studyPeriodService.fetchStudyPeriods(page: page);
      setState(() {
        _studyPeriodList = result['studyPeriods'];
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
                  'Đợt học tập',
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
                          builder: (context) => const StudyPeriodCreate()),
                    ).then((_) => _fetchData(page: 1));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search (Tạm thời vô hiệu hóa)
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
                  ),
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
                : _studyPeriodList.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Không có dữ liệu đợt học tập.'),
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
                          columns: const [
                            DataColumn(label: Text('Mã')),
                            DataColumn(label: Text('Tên đợt')),
                            DataColumn(label: Text('Học kỳ')),
                            DataColumn(label: Text('Năm học')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _studyPeriodList
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

  DataRow _buildDataRow(StudyPeriod studyPeriod, int index) {
    final Color rowColor = index.isEven ? Colors.white : Colors.grey[50]!;

    // Lấy tên học kỳ
    final String semesterName = studyPeriod.semester?.name ?? 'N/A';
    // Lấy tên năm học
    final String academicYearText = studyPeriod.semester?.academicYear != null
        ? '${studyPeriod.semester!.academicYear!.startYear} - ${studyPeriod.semester!.academicYear!.endYear}'
        : 'N/A';

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(studyPeriod.id.toString())),
        DataCell(Text(studyPeriod.name)),
        DataCell(Text(semesterName)), // Hiển thị tên học kỳ
        DataCell(Text(academicYearText)), // Hiển thị năm học
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
                          StudyPeriodEdit(studyPeriod: studyPeriod)),
                ).then((_) => _fetchData(page: _currentPage));
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon:
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              tooltip: 'Xóa',
              onPressed: () => _handleDelete(studyPeriod.id),
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
        content: const Text('Bạn có chắc chắn muốn xóa đợt học tập này?'),
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
        await _studyPeriodService.deleteStudyPeriod(id);
        _fetchData(page: _currentPage);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Xóa đợt học tập thành công!'),
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