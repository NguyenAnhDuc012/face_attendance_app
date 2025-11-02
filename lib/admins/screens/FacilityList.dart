import 'package:flutter/material.dart';

import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/Facility.dart';
import '../services/FacilityService.dart';
import 'FacilityCreate.dart';
import 'FacilityEdit.dart';

class FacilityList extends StatefulWidget {
  const FacilityList({Key? key}) : super(key: key);

  @override
  State<FacilityList> createState() => _FacilityListState();
}

class _FacilityListState extends State<FacilityList> {
  final String _currentPage = 'Facility';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: [
                TopBar(title: 'Cơ sở đào tạo', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: FacilityTableCard(),
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

class FacilityTableCard extends StatefulWidget {
  const FacilityTableCard({Key? key}) : super(key: key);

  @override
  State<FacilityTableCard> createState() => _FacilityTableCardState();
}

class _FacilityTableCardState extends State<FacilityTableCard> {
  final FacilityService _facilityService = FacilityService();

  List<Facility> _facilityList = [];
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
      var result = await _facilityService.fetchFacilities(page: page);

      setState(() {
        _facilityList = result['facilities'];
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
            backgroundColor: Colors.red,
          ),
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
                  'Cơ sở đào tạo',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FacilityCreate(),
                      ),
                    ).then((_) => _fetchData(page: 1)); // Tải lại trang đầu
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
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
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
                : _facilityList.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Không có dữ liệu cơ sở đào tạo.'),
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
                          minWidth: constraints.maxWidth,
                        ),
                        child: DataTable(
                          horizontalMargin: 24.0,
                          columnSpacing: 32.0,
                          headingRowColor: MaterialStateProperty.all(
                            Colors.grey[100],
                          ),
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
                            DataColumn(label: Text('Tên cơ sở đào tạo')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _facilityList
                              .asMap()
                              .entries
                              .map(
                                (entry) => _buildDataRow(entry.value, entry.key),
                          )
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
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        onPressed: _currentPage > 1
                            ? () => _goToPage(_currentPage - 1)
                            : null,
                      ),
                      Text(
                        'Trang $_currentPage / $_lastPage',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
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

  DataRow _buildDataRow(Facility facility, int index) {
    final Color rowColor = index.isEven ? Colors.white : Colors.grey[50]!;

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(facility.id.toString())),
        DataCell(Text(facility.name)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                tooltip: 'Chỉnh sửa',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacilityEdit(facility: facility),
                    ),
                  ).then((_) => _fetchData(page: _currentPage));
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                tooltip: 'Xóa',
                onPressed: () => _handleDelete(facility.id),
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
        content: const Text('Bạn có chắc chắn muốn xóa cơ sở đào tạo này?'),
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
        await _facilityService.deleteFacility(id);
        _fetchData(page: _currentPage);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa cơ sở đào tạo thành công!'),
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
