import 'package:flutter/material.dart';

import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/Room.dart';
import '../services/RoomService.dart';
import 'RoomCreate.dart';
import 'RoomEdit.dart';

class RoomList extends StatefulWidget {
  const RoomList({Key? key}) : super(key: key);

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  final String _currentPage = 'Room';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: const [
                TopBar(title: 'Phòng', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.0),
                    child: RoomsTableCard(),
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

class RoomsTableCard extends StatefulWidget {
  const RoomsTableCard({Key? key}) : super(key: key);

  @override
  State<RoomsTableCard> createState() => _RoomsTableCardState();
}

class _RoomsTableCardState extends State<RoomsTableCard> {
  final RoomService _roomService = RoomService();

  List<Room> _roomsList = [];
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
      var result = await _roomService.fetchRooms(page: page);
      setState(() {
        _roomsList = result['rooms'];
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
    if (page >= 1 && page <= _lastPage) _fetchData(page: page);
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
                Text('Phòng', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RoomCreate()),
                    ).then((_) => _fetchData(page: 1));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
                : _roomsList.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('Không có dữ liệu phòng.')))
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
                          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                          border: TableBorder.all(color: Colors.grey[300]!, width: 1, borderRadius: BorderRadius.circular(8)),
                          columns: const [
                            DataColumn(label: Text('Mã')),
                            DataColumn(label: Text('Tên phòng')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: _roomsList.asMap().entries.map((entry) => _buildDataRow(entry.value, entry.key)).toList(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back_ios, size: 16), onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null),
                      Text('Trang $_currentPage / $_lastPage', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: _currentPage < _lastPage ? () => _goToPage(_currentPage + 1) : null),
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

  DataRow _buildDataRow(Room room, int index) {
    final rowColor = index.isEven ? Colors.white : Colors.grey[50]!;

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(room.id.toString())),
        DataCell(Text(room.name)),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              tooltip: 'Chỉnh sửa',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RoomEdit(room: room)))
                    .then((_) => _fetchData(page: _currentPage));
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              tooltip: 'Xóa',
              onPressed: () => _handleDelete(room.id),
            ),
          ],
        )),
      ],
    );
  }

  Future<void> _handleDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa phòng này?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _roomService.deleteRoom(id);
        _fetchData(page: _currentPage);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xóa phòng thành công!'), backgroundColor: Colors.green));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi xóa: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
