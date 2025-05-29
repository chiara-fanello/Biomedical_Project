import 'package:flutter/material.dart';

class Lesson13 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson13')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Importance of Responsibility and Honesty',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Responsibility and honesty are core values that build trust and integrity. Being responsible means taking care of our duties, whether at school, home, or work. Honesty involves telling the truth and acting sincerely. These qualities help us earn respect and develop good relationships with others. Making responsible and honest choices also means considering the consequences of our actions on others and the environment. Practicing these virtues every day creates a more trustworthy and fair community.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
