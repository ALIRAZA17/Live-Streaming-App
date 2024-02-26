import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';

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
