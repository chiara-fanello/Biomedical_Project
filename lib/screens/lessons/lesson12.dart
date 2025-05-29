import 'package:flutter/material.dart';

class Lesson12 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson12')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Significance of Creativity and Imagination',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Creativity and imagination are powerful tools for personal growth and innovation. They allow us to solve problems, express ourselves, and dream of new possibilities. Arts, music, writing, and inventions all stem from the ability to think creatively. Encouraging imagination in children and adults helps develop confidence and open-mindedness. Creativity is not only for artists but for everyone who wants to find unique solutions and improve the world. Fostering a creative mindset leads to personal fulfillment and societal progress.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
