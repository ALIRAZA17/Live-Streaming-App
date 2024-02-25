import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';

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

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  String qrData = ""; // Initialize with empty string
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

class ConnectYourDeviceToPower extends StatelessWidget {
  const ConnectYourDeviceToPower({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Device to Power'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25),
        child: Column(
          children: [
            Image.asset(
              'assets/images/power.png', // Path to the image
              width: 300, // Adjust width as needed
              height: 300, // Adjust height as needed
            ),
            const Text(
              'Connect your device to the power supply. '
              'Then check if the indicator light turns on.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConnectionToWifi(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Yellow button
              ),
              // Navigate to ConnectionToWifi screen
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionToWifi extends StatefulWidget {
  const ConnectionToWifi({super.key});

  @override
  ConnectionToWifiState createState() => ConnectionToWifiState();
}

class ConnectionToWifiState extends State<ConnectionToWifi> {
  bool isConnectedToWifi = false;

  @override
  void initState() {
    super.initState();
    _checkWifiConnection();
  }

  Future<void> _checkWifiConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isConnectedToWifi = true;
      });
      _navigateToWifiPasswordScreen();
    }
  }

  void _navigateToWifiPasswordScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WifiPassword(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection to Wi-Fi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please confirm your phone is connected to Wi-Fi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              if (!isConnectedToWifi)
                ElevatedButton(
                  onPressed: _navigateToWifiPasswordScreen,
                  child: const Text('Enter Wi-Fi Password'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WifiPassword extends StatefulWidget {
  const WifiPassword({super.key});

  @override
  WifiPasswordState createState() => WifiPasswordState();
}

class WifiPasswordState extends State<WifiPassword> {
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _connectToWifi() async {
    final password = _passwordController.text;
    if (password.isNotEmpty && password.length >= 8) {
      try {
        bool? connectionResult = await WiFiForIoTPlugin.connect(
          "SSID",
          password: "PASSWORD",
          security: NetworkSecurity.WPA,
        );
        if (connectionResult == true) {
          // Successfully connected to Wi-Fi
        } else {
          // Failed to connect to Wi-Fi
        }
      } catch (e) {
        // Handle exception
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter a valid Wi-Fi password (minimum length: 8 characters).')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Wi-Fi Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Wi-Fi Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _connectToWifi,
              child: const Text('Connect to Wi-Fi'),
            ),
          ],
        ),
      ),
    );
  }
}

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
