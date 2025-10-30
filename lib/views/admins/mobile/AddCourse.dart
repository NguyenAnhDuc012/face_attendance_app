import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Nền màu xám nhạt như trong hình
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Inter',
        // Định nghĩa style chuẩn cho các ô nhập liệu
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.indigo.shade700, width: 2.0),
          ),
        ),
      ),
      home: const AddClassScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen>
    with SingleTickerProviderStateMixin {
  // Index của BottomNavBar, 2 tương ứng với icon "Description" (Tài liệu)
  int _selectedBottomNavIndex = 2;
  late TabController _tabController;

  // Dữ liệu giả lập cho lịch học
  late List<Map<String, dynamic>> scheduleDays;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Khởi tạo dữ liệu từ Thứ 2 -> Thứ 7
    scheduleDays = List.generate(6, (index) {
      return {
        'day': 'Thứ ${index + 2}',
        'isChecked': index == 1, // Thứ 3 được chọn
        'time': index == 1 ? '07:00 - 08:55' : null, // Chỉ Thứ 3 có giờ
        'room': index == 1 ? '302 - B5' : null, // Chỉ Thứ 3 có phòng
      };
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------------------------
      // APP BAR
      // ------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.grey[50], // Nền xám nhạt
        foregroundColor: Colors.black, // Icon màu đen
        elevation: 0, // Không có đổ bóng
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'Thêm lớp học phần',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/meo.jpg'),
            ),
          ),
        ],
      ),

      // ------------------------------------
      // BODY CỦA ỨNG DỤNG
      // ------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tên lớp ---
            _buildLabel('Tên lớp'),
            _buildSimpleDropdown(
              value: '64KTPM.NB',
              items: ['64KTPM.NB', '63KTPM.NB', '62KTPM.NB'],
              onChanged: (value) {},
            ),

            // --- Tên môn học (có viền xanh) ---
            _buildLabel('Tên môn học'),
            _buildHighlightedDropdown(
              value: 'Lập trình Mobile',
              items: ['Lập trình Mobile', 'Học tăng cường', 'Tư tưởng HCM'],
              onChanged: (value) {},
            ),

            // --- Hàng Buổi lý thuyết / Buổi thực hành ---
            Row(
              children: [
                Expanded(
                  child: _buildSmallTextField(
                    label: 'Buổi lý thuyết',
                    initialValue: '30',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallTextField(
                    label: 'Buổi thực hành',
                    initialValue: '15',
                  ),
                ),
              ],
            ),

            // --- Hàng Ngày bắt đầu / Ngày kết thúc ---
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Ngày bắt đầu',
                    initialValue: '01/01/2025',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    label: 'Ngày kết thúc',
                    initialValue: '01/03/2025',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- TabBar Lý thuyết / Thực hành ---
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.indigo.shade700,
              indicatorWeight: 3.0,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: 'Lý thuyết'),
                Tab(text: 'Thực hành'),
              ],
            ),

            // --- Nội dung của Tab ---
            // (Chỉ hiển thị nội dung cho tab đầu tiên)
            _buildScheduleEditor(),

            const SizedBox(height: 32),

            // --- Nút Lưu ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),

      // ------------------------------------
      // BOTTOM NAVIGATION BAR
      // ------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.grey[850],
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Docs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }

  // --- WIDGET TRỢ GIÚP ---

  // Tiêu đề (label) cho mỗi trường
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Dropdown thường (viền xám)
  Widget _buildSimpleDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true, // <-- THÊM DÒNG NÀY
      items: items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis, // <-- THÊM DÒNG NÀY
            softWrap: false,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Dropdown đặc biệt (viền xanh)
  Widget _buildHighlightedDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.blue, width: 2.0),
        color: Colors.white,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none, // Bỏ viền của chính Dropdown
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
      ),
    );
  }

  // Ô nhập text nhỏ
  Widget _buildSmallTextField({
    required String label,
    required String initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          initialValue: initialValue,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Ô nhập ngày (có icon)
  Widget _buildDateField({
    required String label,
    required String initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
        ),
      ],
    );
  }

  // Khối "Chọn lịch học"
  Widget _buildScheduleEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Chọn lịch học'),
        // Dùng ...spread operator để trải list widget ra
        ...scheduleDays.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> data = entry.value;
          return _buildScheduleRow(
            day: data['day'],
            isChecked: data['isChecked'],
            selectedTime: data['time'],
            selectedRoom: data['room'],
            onCheckedChanged: (value) {
              setState(() {
                scheduleDays[index]['isChecked'] = value ?? false;
              });
            },
            onTimeChanged: (value) {
              setState(() {
                scheduleDays[index]['time'] = value;
              });
            },
            onRoomChanged: (value) {
              setState(() {
                scheduleDays[index]['room'] = value;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  // Một hàng trong "Chọn lịch học"
  Widget _buildScheduleRow({
    required String day,
    required bool isChecked,
    String? selectedTime,
    String? selectedRoom,
    required void Function(bool?) onCheckedChanged,
    required void Function(String?) onTimeChanged,
    required void Function(String?) onRoomChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(value: isChecked, onChanged: onCheckedChanged),
              Text(
                day,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Chỉ hiển thị dropdown nếu được check
          if (isChecked)
            Padding(
              // Lùi vào 48px (bằng Checkbox + padding)
              padding: const EdgeInsets.only(left: 48.0, top: 8.0),
              child: Column(
                // Căn lề trái cho các label
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Thêm Label cho Giờ học ---
                  _buildLabel('Giờ học'),
                  _buildSimpleDropdown(
                    value: selectedTime ?? '07:00 - 08:55',
                    items: ['07:00 - 08:55', '09:00 - 10:55', '13:00 - 14:55'],
                    onChanged: onTimeChanged,
                  ),

                  // Khoảng cách dọc
                  const SizedBox(height: 12),

                  // --- Thêm Label cho Phòng học ---
                  _buildLabel('Phòng học'),
                  _buildSimpleDropdown(
                    value: selectedRoom ?? '302 - B5',
                    items: ['302 - B5', '401 - A2', '101 - C1'],
                    onChanged: onRoomChanged,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
