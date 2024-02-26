import 'package:camera/wifi_password_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

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
