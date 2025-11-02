import 'package:flutter/material.dart';

import '../layouts/app_footer.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../models/Intake.dart';
import '../services/IntakeService.dart';
import 'IntakeCreate.dart';
import 'IntakeEdit.dart';

class IntakeList extends StatefulWidget {
  const IntakeList({Key? key}) : super(key: key);

  @override
  State<IntakeList> createState() => _IntakeListState();
}

class _IntakeListState extends State<IntakeList> {
  final String _currentPage = 'Intake';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentPage: _currentPage),
          Expanded(
            child: Column(
              children: const [
                TopBar(title: 'Khóa học', subtitle: 'Danh sách'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.0),
                    child: IntakesTableCard(),
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

class IntakesTableCard extends StatefulWidget {
  const IntakesTableCard({Key? key}) : super(key: key);

  @override
  State<IntakesTableCard> createState() => _IntakesTableCardState();
}

class _IntakesTableCardState extends State<IntakesTableCard> {
  late Future<List<Intake>> _futureIntakes;
  final IntakeService _intakeService = IntakeService();
  List<Intake> _intakesList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _futureIntakes = _intakeService.fetchIntakes();
    });
  }

  Future<void> _handleDelete(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa khóa học này?'),
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
        await _intakeService.deleteIntake(id);
        setState(() {
          _intakesList.removeWhere((intake) => intake.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa khóa học thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xóa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Khóa học',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm mới'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IntakeCreate(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Search ---
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Bảng dữ liệu ---
            SizedBox(
              width: double.infinity,
              child: FutureBuilder<List<Intake>>(
                future: _futureIntakes,
                builder: (context, snapshot) {
                  // Hiển thị vòng tròn loading giữa màn hình.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Nếu API bị lỗi → hiện thông báo lỗi màu đỏ.
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi khi tải dữ liệu: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  // Khi API trả về danh sách trống → hiển thị thông báo “Không có dữ liệu”.
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu khóa học.'),
                    );
                  }

                  // Khi có dữ liệu:
                  _intakesList = snapshot.data!;

                  return DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey[200],
                    ),
                    columns: const [
                      DataColumn(label: Text('Mã')),
                      DataColumn(label: Text('Tên khóa')),
                      DataColumn(label: Text('Năm bắt đầu')),
                      DataColumn(label: Text('Năm kết thúc')),
                      DataColumn(label: Text('Hành động')),
                    ],
                    rows: _intakesList.map((intake) {
                      return _buildDataRow(intake);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(Intake intake) {
    return DataRow(
      cells: [
        DataCell(Text(intake.id.toString())),
        DataCell(Text(intake.name)),
        DataCell(Text(intake.startYear.toString())),
        DataCell(Text(intake.expectedGraduationYear.toString())),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntakeEdit(intake: intake),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _handleDelete(intake.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
