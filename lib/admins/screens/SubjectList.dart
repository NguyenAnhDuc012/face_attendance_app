import 'package:flutter/material.dart';
import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/Subject.dart';
import '../services/SubjectService.dart';
import 'SubjectCreate.dart';
import 'SubjectEdit.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({Key? key}) : super(key: key);

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  final String _currentPage = 'Subject';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                TopBar(title: 'Môn học', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: SubjectTableCard(),
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

class SubjectTableCard extends StatefulWidget {
  const SubjectTableCard({Key? key}) : super(key: key);

  @override
  State<SubjectTableCard> createState() => _SubjectTableCardState();
}

class _SubjectTableCardState extends State<SubjectTableCard> {
  final SubjectService _subjectService = SubjectService();

  List<Subject> _subjectList = [];
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
      var result = await _subjectService.fetchSubjects(page: page);
      setState(() {
        _subjectList = result['subjects'];
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
                  'Môn học',
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
                          builder: (context) => const SubjectCreate()),
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
                : _subjectList.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Không có dữ liệu môn học.'),
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
                            DataColumn(label: Text('Tên môn học')),
                            DataColumn(label: Text('Số tín chỉ')),
                            DataColumn(label: Text('Bộ môn')),
                            DataColumn(label: Text('Khoa')),
                            DataColumn(label: Text('Cơ sở')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _subjectList
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

  DataRow _buildDataRow(Subject subject, int index) {
    final Color rowColor = index.isEven ? Colors.white : Colors.grey[50]!;

    // Lấy tên bộ môn
    final String departmentName = subject.department?.name ?? 'N/A';
    // Lấy tên khoa
    final String facultyName = subject.department?.faculty?.name ?? 'N/A';
    // Lấy tên cơ sở
    final String facilityName = subject.department?.faculty?.facility?.name ?? 'N/A';


    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(subject.id.toString())),
        DataCell(Text(subject.name)),
        DataCell(Text(subject.credits.toString())), // Hiển thị tín chỉ
        DataCell(Text(departmentName)), // Hiển thị tên bộ môn
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
                          SubjectEdit(subject: subject)),
                ).then((_) => _fetchData(page: _currentPage));
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon:
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              tooltip: 'Xóa',
              onPressed: () => _handleDelete(subject.id),
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
        content: const Text('Bạn có chắc chắn muốn xóa môn học này?'),
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
        await _subjectService.deleteSubject(id);
        _fetchData(page: _currentPage);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Xóa môn học thành công!'),
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