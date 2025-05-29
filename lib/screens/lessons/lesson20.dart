import 'package:flutter/material.dart';

class Lesson20 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson19')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Power of Hope and Positivity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Hope and positivity are important for facing life''s challenges. Believing in a better future helps us stay motivated and resilient, even in difficult times. A positive attitude spreads happiness and encourages others around us. Focusing on solutions rather than problems allows us to find ways to overcome obstacles. Cultivating hope and optimism makes life more meaningful and inspires us to work toward our dreams and a better world.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
