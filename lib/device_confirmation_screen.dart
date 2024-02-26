import 'package:flutter/material.dart';

class DeviceConfirmationScreen extends StatelessWidget {
  const DeviceConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Confirmation'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Device successfully connected to Wi-Fi!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
