import 'package:flutter/material.dart';
import '../layouts/sidebar.dart';
import '../layouts/top_bar.dart';
import '../layouts/app_footer.dart';
import '../models/Faculty.dart';
import '../models/Facility.dart';
import '../services/FacultyService.dart';
import '../services/FacilityService.dart';
import '../screens/FacultyList.dart';

class FacultyEdit extends StatefulWidget {
  final Faculty faculty;
  const FacultyEdit({Key? key, required this.faculty}) : super(key: key);

  @override
  State<FacultyEdit> createState() => _FacultyEditState();
}

class _FacultyEditState extends State<FacultyEdit> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final FacultyService _facultyService = FacultyService();
  final FacilityService _facilityService = FacilityService();
  bool _isLoading = false;

  List<Facility> _facilities = [];
  Facility? _selectedFacility;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.faculty.name);
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    try {
      var result = await _facilityService.fetchFacilities();
      setState(() {
        _facilities = result['facilities'];
        _selectedFacility = _facilities.isNotEmpty
            ? _facilities.firstWhere(
                (f) => f.id == widget.faculty.facilityId,
                orElse: () => _facilities.first,
              )
            : null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải cơ sở: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedFacility == null) return;

    setState(() => _isLoading = true);

    try {
      await _facultyService.updateFaculty(
        id: widget.faculty.id,
        name: _nameController.text,
        facilityId: _selectedFacility!.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật khoa thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FacultyList()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi cập nhật khoa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentPage: 'Faculty'),
          Expanded(
            child: Column(
              children: [
                const TopBar(title: 'Khoa', subtitle: 'Sửa'),
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
                                              const FacultyList(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Quay lại'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sửa khoa',
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
                                    labelText: 'Tên khoa',
                                    prefixIcon: Icon(Icons.school_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Vui lòng nhập tên khoa'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<Facility>(
                                  value: _selectedFacility,
                                  items: _facilities
                                      .map(
                                        (f) => DropdownMenuItem(
                                          value: f,
                                          child: Text(f.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedFacility = val),
                                  decoration: const InputDecoration(
                                    labelText: 'Chọn cơ sở',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) => val == null
                                      ? 'Vui lòng chọn cơ sở'
                                      : null,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
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
