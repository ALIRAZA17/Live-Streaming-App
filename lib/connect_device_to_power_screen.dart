import 'package:camera/connect_to_wifi.dart';
import 'package:flutter/material.dart';

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
