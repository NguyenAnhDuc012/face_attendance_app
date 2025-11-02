import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/StudentClass.dart';
import '../services/StudentClassService.dart';
import 'StudentClassCreate.dart';
import 'StudentClassEdit.dart';

class StudentClassList extends StatefulWidget {
  const StudentClassList({Key? key}) : super(key: key);

  @override
  State<StudentClassList> createState() => _StudentClassListState();
}

class _StudentClassListState extends State<StudentClassList> {
  final String _currentPage = 'StudentClass';
  final StudentClassService _service = StudentClassService();

  List<StudentClass> _classes = [];
  int _currentPageNum = 1;
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
      var result = await _service.fetchStudentClasses(page: page);
      setState(() {
        _classes = result['studentClasses'];
        _currentPageNum = result['current_page'];
        _lastPage = result['last_page'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải dữ liệu: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _lastPage) _fetchData(page: page);
  }

  Future<void> _handleDelete(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa lớp học này?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deleteStudentClass(id);
        _fetchData(page: _currentPageNum);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa lớp học thành công!'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi xóa: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Lớp học', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header + button thêm mới
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Lớp học', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Thêm mới'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const StudentClassCreate()),
                                    ).then((_) => _fetchData(page: 1));
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Search (placeholder)
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 300,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Tìm kiếm...',
                                    hintStyle: TextStyle(color: Colors.grey[500]),
                                    prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.primaryColor)),
                                  ),
                                  onChanged: (value) {
                                    // TODO: Search logic
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Table
                            _isLoading
                                ? const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                                : _classes.isEmpty
                                ? const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('Không có dữ liệu lớp học.')))
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) => SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                      child: DataTable(
                                        horizontalMargin: 24,
                                        columnSpacing: 32,
                                        headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                                        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                        border: TableBorder.all(color: Colors.grey[300]!, width: 1, borderRadius: BorderRadius.circular(8)),
                                        columns: const [
                                          DataColumn(label: Text('Mã')),
                                          DataColumn(label: Text('Tên lớp')),
                                          DataColumn(label: Text('Hành động')),
                                        ],
                                        rows: _classes.asMap().entries.map((e) => _buildDataRow(e.value, e.key)).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Pagination
                                Container(
                                  padding: const EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[300]!))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          icon: const Icon(Icons.arrow_back_ios, size: 16),
                                          onPressed: _currentPageNum > 1 ? () => _goToPage(_currentPageNum - 1) : null),
                                      Text('Trang $_currentPageNum / $_lastPage', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      IconButton(
                                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                          onPressed: _currentPageNum < _lastPage ? () => _goToPage(_currentPageNum + 1) : null),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  DataRow _buildDataRow(StudentClass sc, int index) {
    final Color rowColor = index.isEven ? Colors.white : Colors.grey[50]!;
    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(sc.id.toString())),
        DataCell(Text(sc.name)),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentClassEdit(studentClass: sc)))
                    .then((_) => _fetchData(page: _currentPageNum));
              },
            ),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => _handleDelete(sc.id)),
          ],
        )),
      ],
    );
  }
}
