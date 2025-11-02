// lib/widgets/app_footer.dart
import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: const Center(
        child: Text(
          'Cùng học flutter 2025@ !',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}