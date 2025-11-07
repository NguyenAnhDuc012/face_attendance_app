// lib/screens/student_attendance_screen.dart
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../main_student.dart';
import '../model/student_course_session.dart';
import '../services/student_attendance_service.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final StudentCourseSession session;
  const StudentAttendanceScreen({super.key, required this.session});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  String _currentState = 'scanning_qr';

  // Cho QR
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;
  String? _scannedToken;

  // Cho Camera
  CameraController? _cameraController;
  XFile? _capturedImage;
  bool _isCameraReady = false;

  // Cho Loading
  bool _isLoading = false;
  String _loadingMessage = 'Đang quét QR...';

  @override
  void initState() {
    super.initState();
    // (QRView sẽ tự khởi động camera)
  }

  @override
  void dispose() {
    _qrController?.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    // Tìm camera TRƯỚC
    final frontCamera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      print("Lỗi mở camera: $e");
    }
  }

  // Xử lý khi quét QR
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });
    // Nghe luồng dữ liệu quét
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera(); // Dừng quét

      setState(() {
        _scannedToken = scanData.code;
        _currentState = 'taking_photo'; // Chuyển sang bước chụp ảnh
        _loadingMessage = 'Đang mở camera...';
        _isLoading = true; // Hiển thị loading
      });

      // Mở camera (có thể mất 1-2 giây)
      _initializeCamera().then((_) {
        setState(() {
          _isLoading = false; // Tắt loading khi camera sẵn sàng
        });
      });
    });
  }

  // Xử lý khi chụp ảnh
  Future<void> _takePicture() async {
    if (!_isCameraReady || _cameraController == null) return;
    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = image;
        _currentState = 'submitting'; // Đổi trạng thái
        _submitAttendance(); // Tự động nộp
      });
    } catch (e) {
      print("Lỗi chụp ảnh: $e");
    }
  }

  // HÀM CHÍNH: GỌI SERVICE ĐỂ ĐIỂM DANH
  Future<void> _submitAttendance() async {
    if (_scannedToken == null || _capturedImage == null) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Đang xác thực...';
    });

    try {
      await StudentAttendanceService.submitFaceAttendance(
        sessionId: widget.session.sessionId,
        qrToken: _scannedToken!,
        faceImage: File(_capturedImage!.path),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Điểm danh thành công!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Trả về thành công
      }

    } catch (e) {
      // BẮT LỖI TỪ LARAVEL/PYTHON (VÍ DỤ: KHUÔN MẶT KHÔNG KHỚP)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4), // Cho 4 giây
          ),
        );
      }
      // Cho phép thử lại
      setState(() {
        _isLoading = false;
        _currentState = 'taking_photo'; // Quay lại bước chụp ảnh
        _capturedImage = null; // Xóa ảnh cũ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điểm danh QR & Khuôn mặt')),
      body: Center(
        child: _buildCurrentView(),
      ),
    );
  }

  // Hiển thị view tùy theo trạng thái
  Widget _buildCurrentView() {
    // Luôn ưu tiên hiển thị loading
    if (_isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(_loadingMessage, style: const TextStyle(fontSize: 16)),
        ],
      );
    }

    if (_currentState == 'scanning_qr') {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Vui lòng quét QR Code do Giảng viên cung cấp.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      );
    }

    if (_currentState == 'taking_photo') {
      // (Trạng thái camera loading đã được _isLoading xử lý)
      if (!_isCameraReady) {
        return const Center(child: Text('Không thể khởi động camera.'));
      }

      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Giữ khuôn mặt của bạn trong khung hình.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Chụp ảnh', style: TextStyle(fontSize: 18)),
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
        ],
      );
    }

    return Container(); // Trạng thái 'submitting' đã được _isLoading xử lý
  }
}