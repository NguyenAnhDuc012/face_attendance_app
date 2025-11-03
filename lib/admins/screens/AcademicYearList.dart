import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/AcademicYear.dart';
import '../services/AcademicYearService.dart';
import 'AcademicYearCreate.dart';
import 'AcademicYearEdit.dart';

class AcademicYearList extends StatefulWidget {
  const AcademicYearList({Key? key}) : super(key: key);

  @override
  State<AcademicYearList> createState() => _AcademicYearListState();
}

class _AcademicYearListState extends State<AcademicYearList> {
  final String _currentPage = 'Academic Year';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                TopBar(title: 'Năm học', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.0),
                    child: AcademicYearTableCard(),
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

class AcademicYearTableCard extends StatefulWidget {
  const AcademicYearTableCard({Key? key}) : super(key: key);

  @override
  State<AcademicYearTableCard> createState() => _AcademicYearTableCardState();
}

class _AcademicYearTableCardState extends State<AcademicYearTableCard> {
  final AcademicYearService _service = AcademicYearService();

  List<AcademicYear> _list = [];
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
      var result = await _service.fetchAcademicYears(page: page);
      setState(() {
        _list = result['academicYears'];
        _currentPage = result['current_page'];
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
                  'Năm học',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AcademicYearCreate()),
                    ).then((_) => _fetchData(page: 1));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 320,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Table
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _list.isEmpty
                ? const Center(child: Text('Không có dữ liệu năm học.'))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          horizontalMargin: 24.0,
                          columnSpacing: 32.0,
                          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                          headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                          border: TableBorder.all(
                              color: Colors.grey[300]!, width: 1, borderRadius: BorderRadius.circular(8)),
                          columns: const [
                            DataColumn(label: Text('Mã')),
                            DataColumn(label: Text('Năm học')),
                            DataColumn(label: Text('Ngày BĐ')),
                            DataColumn(label: Text('Ngày KT')),
                            DataColumn(label: Text('Trạng thái')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _list.asMap().entries.map((entry) => _buildDataRow(entry.value, entry.key)).toList(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
                    ),
                    Text('Trang $_currentPage / $_lastPage', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: _currentPage < _lastPage ? () => _goToPage(_currentPage + 1) : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(AcademicYear item, int index) {
    final rowColor = index.isEven ? Colors.white : Colors.grey[50]!;

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(item.id.toString())),
        DataCell(Text('${item.startYear} - ${item.endYear}')),

        // Gọi hàm helper để hiển thị ngày BĐ
        DataCell(Text(_formatDateForDisplay(item.startDate))),
        // Gọi hàm helper để hiển thị ngày KT
        DataCell(Text(_formatDateForDisplay(item.endDate))),

        // Hiển thị trạng thái
        DataCell(
          Chip(
            label: Text(
              item.isActive ? 'Hoạt động' : 'Không',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: item.isActive ? Colors.green : Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            labelStyle: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                tooltip: 'Chỉnh sửa',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AcademicYearEdit(item: item)),
                  ).then((_) => _fetchData(page: _currentPage));
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                tooltip: 'Xóa',
                onPressed: () => _handleDelete(item.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleDelete(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa năm học này?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deleteAcademicYear(id);
        _fetchData(page: _currentPage);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa năm học thành công!'), backgroundColor: Colors.green),
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
}