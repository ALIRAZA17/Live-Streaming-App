import 'package:camera/add_device_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  String qrData = "";
  bool isScanCompleted = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Remove default app bar background
        elevation: 0,
        // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      // Light gray background
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Text(
                                'Please scan the QR code used for sharing devices or the one located on the label / cable or body of the device',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: SizedBox(
                                  width: 240,
                                  height: 240,
                                  child: QRView(
                                    key: qrKey,
                                    onQRViewCreated: _onQRViewCreated,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: (qrData.isNotEmpty)
                        ? Text(
                            'Device: $qrData',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        : const Text(
                            'Scan a code',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (kDebugMode) {
        print('Scan Data = ${scanData.code}');
      }
      String sanitizedCode = scanData.code ?? '';
      if (kDebugMode) {
        print('Sanitized Code = $sanitizedCode');
      }

      // Remove the braces from the sanitized code
      sanitizedCode = sanitizedCode.replaceAll('{', '').replaceAll('}', '');

      // Split the sanitized code into individual key-value pairs
      List<String> keyValuePairs = sanitizedCode.split(',');

      Map<String, String> qrData = {};
      // Extract key-value pairs from each string in keyValuePairs list
      for (String pair in keyValuePairs) {
        List<String> keyValue = pair.split(':');
        if (keyValue.length == 2) {
          qrData[keyValue[0].trim()] = keyValue[1].trim();
        }
      }

      if (kDebugMode) {
        print('QR Data = $qrData');
      }

      // Ensure that QR data contains all required fields
      if (!qrData.containsKey('SN') ||
          !qrData.containsKey('DT') ||
          !qrData.containsKey('SC') ||
          !qrData.containsKey('NC')) {
        if (kDebugMode) {
          print('Error: Invalid QR code data format');
        }
        return;
      }

      // Extract individual information from QR data
      String sn = qrData['SN'] ?? ''; // Serial Number
      String dt = qrData['DT'] ?? ''; // Device Type
      String sc = qrData['SC'] ?? ''; // Some Code
      String nc = qrData['NC'] ?? ''; // Another Code

      if (kDebugMode) {
        print(
            'Serial Number: $sn, Device Type: $dt, Some Code: $sc, Another Code: $nc');
      }

      // Navigate to AddDeviceScreen with extracted data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddDeviceScreen(
            serialNumber: sn,
            deviceType: dt,
            someCode: sc,
            anotherCode: nc,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
