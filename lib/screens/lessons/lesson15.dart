import 'package:flutter/material.dart';

class Lesson15 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson15')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Role of Technology in Education',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Technology has transformed education by providing new tools for learning. Tablets, computers, and the internet allow students to access information easily and engage in interactive lessons. Distance learning makes education accessible to more people, regardless of location. Technology also encourages creativity and collaboration among students. However, it’s important to use digital tools responsibly, respecting privacy and avoiding distractions. Integrating technology effectively can make learning more engaging, inclusive, and prepared for the future.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
