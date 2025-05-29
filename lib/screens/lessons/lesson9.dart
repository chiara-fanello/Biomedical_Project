import 'package:flutter/material.dart';

class Lesson9 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson9')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Role of Digital Technologies for Sustainable Development',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Digital technologies are transforming how we live, work, and relate, offering new opportunities to promote sustainable development. The Internet, big data, and artificial intelligence help monitor environmental changes, optimize resource use, and facilitate global education and awareness. Technologies can improve energy efficiency, enable remote work, and reduce travel, contributing to lower pollution. However, it’s important to use these innovations responsibly, avoiding excessive energy consumption and safeguarding privacy. Digitalization can also promote social inclusion and access to information, strengthening democratic participation. Harnessing the full potential of digital technologies means accelerating progress toward a fairer, more sustainable, and connected world.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
