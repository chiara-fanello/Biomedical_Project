import 'package:flutter/material.dart';

class Lesson14 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson14')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Benefits of Volunteering and Helping Others',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Volunteering is a way to give back to the community and help those in need. It can be as simple as helping a neighbor, participating in a charity event, or supporting environmental projects. Volunteering develops empathy, teamwork, and a sense of purpose. It also makes a positive difference in people''s lives and strengthens social bonds. Everyone can find a way to contribute their time and skills. Helping others creates a more compassionate and united society, where everyone feels supported and valued.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
