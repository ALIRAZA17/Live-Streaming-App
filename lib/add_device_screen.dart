import 'package:camera/connect_device_to_power_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddDeviceScreen extends StatelessWidget {
  final String serialNumber;
  final String deviceType;
  final String someCode;
  final String anotherCode;

  const AddDeviceScreen({
    super.key,
    required this.serialNumber,
    required this.deviceType,
    required this.someCode,
    required this.anotherCode,
  });

  @override
  Widget build(BuildContext context) {
    // Check for empty codes before processing
    if (serialNumber.isEmpty ||
        deviceType.isEmpty ||
        someCode.isEmpty ||
        anotherCode.isEmpty) {
      return const Center(
        child: Text('Error: Incomplete QR code data received'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Display Serial Number
            _buildDataRow('Serial Number:', serialNumber),
            // Display Device Type
            _buildDataRow('Device Type:', deviceType),
            // Display Some Code
            _buildDataRow('Safety Code:', someCode),
            // Display Another Code
            _buildDataRow('Another Code:', anotherCode),
            const SizedBox(height: 20.0),
            // Display QR image
            QrImageView(
              data: serialNumber, // Or any other code you want to display
              version: QrVersions.auto,
              size: 200.0,
              gapless: false,
            ),
            const SizedBox(height: 20.0),
            // Save QR image button
            ElevatedButton(
              onPressed: () => _saveQrImage(serialNumber),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Yellow button
              ),
              // Call _saveQrImage function
              child: const Text('Save QR Image'),
            ),
            const SizedBox(height: 20.0),
            // Next button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConnectYourDeviceToPower(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Yellow button
              ),
              // Navigate to ConnectYourDeviceToPower screen
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18.0),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  void _saveQrImage(String code) {
    // Implement logic to save QR image using libraries like path_provider
    // and qr_flutter
  }
}
