import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Facility.dart';
import '../services/FacilityService.dart';
import '../screens/FacilityList.dart';

class FacilityEdit extends StatefulWidget {
  final Facility facility;
  const FacilityEdit({Key? key, required this.facility}) : super(key: key);

  @override
  State<FacilityEdit> createState() => _FacilityEditState();
}

class _FacilityEditState extends State<FacilityEdit> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.facility.name);
  final FacilityService _service = FacilityService();
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
      await _service.updateFacility(
        id: widget.facility.id,
        name: _nameController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật cơ sở đào tạo thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FacilityList()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi cập nhật cơ sở đào tạo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentPage: 'Facility'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Cơ sở đào tạo', subtitle: 'Sửa'),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.all(24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
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
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const FacilityList()),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sửa cơ sở đào tạo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tên cơ sở đào tạo',
                                    prefixIcon: Icon(Icons.business_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value == null || value.isEmpty
                                      ? 'Vui lòng nhập tên cơ sở đào tạo'
                                      : null,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                      : const Text(
                                    'Cập nhật',
                                    style: TextStyle(fontSize: 16),
                                  ),
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
