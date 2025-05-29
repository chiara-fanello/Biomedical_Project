import 'package:flutter/material.dart';

class Lesson17 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson17')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Value of Perseverance and Effort',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Perseverance and effort are key to achieving our goals. When we face challenges, not giving up and trying again lead to success. Success often requires patience, hard work, and a positive attitude. Learning from mistakes helps us grow stronger and more skilled. Whether in school, sports, or personal projects, perseverance keeps us motivated and resilient. Cultivating these qualities helps us overcome difficulties and reach our dreams.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
