import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for NIRA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your privacy is important to us. This policy explains how we collect, use, and protect your personal information in accordance with the National ID Registration guidelines.',
            ),
            SizedBox(height: 16),
            Text(
              '1. Data Collection\nWe collect biographical and biometric data as required by law for national identification.',
            ),
            // More content could be added here
          ],
        ),
      ),
    );
  }
}
