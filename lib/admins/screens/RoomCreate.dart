import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../services/RoomService.dart';
import 'RoomList.dart';

class RoomCreate extends StatefulWidget {
  const RoomCreate({Key? key}) : super(key: key);

  @override
  State<RoomCreate> createState() => _RoomCreateState();
}

class _RoomCreateState extends State<RoomCreate> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final RoomService _service = RoomService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _service.createRoom(name: _nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tạo phòng thành công!'), backgroundColor: Colors.green));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RoomList()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi tạo phòng: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentPage: 'Room'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Phòng', subtitle: 'Thêm mới'),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.all(24.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoomList())),
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text('Thêm phòng mới', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                const SizedBox(height: 32),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(labelText: 'Tên phòng', prefixIcon: Icon(Icons.meeting_room_outlined), border: OutlineInputBorder()),
                                  validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên phòng' : null,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                                  child: _isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('Tạo mới', style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
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
}
