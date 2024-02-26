import 'package:camera/camera_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Streaming'),
        actions: [
          _buildOptionsPopupMenu(context),
        ],
      ),
    );
  }

  Widget _buildOptionsPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'scan',
          child: ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text('Scan QR Code'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'addManually',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Manually'),
          ),
        ),
      ],
      onSelected: (String? value) {
        if (value == 'scan') {
          _navigateToScanScreen(context);
        } else if (value == 'addManually') {
          // Handle add manually option
          // Example: navigate to add manually screen
          // _navigateToAddManuallyScreen(context);
        }
      },
    );
  }

  void _navigateToScanScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );
  }
}
