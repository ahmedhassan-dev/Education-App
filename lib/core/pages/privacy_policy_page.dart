import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Introduction\n'
              'This Privacy Policy explains how IronMan edu App collects, uses, and protects your information. By using the App, you agree to the practices described in this policy.\n\n'
              '2. Information We Collect\n'
              'We may collect the following types of information:\n'
              '- Personal Information\n'
              '- Usage Data\n'
              '- Device Information\n\n'
              '3. How We Use Your Information\n'
              '- Managing user accounts and authentication.\n'
              '- Facilitating communication between teachers and students.\n'
              '- Sending notifications.\n\n',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
