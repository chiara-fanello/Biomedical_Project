import 'package:flutter/material.dart';

class Lesson18 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson18')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Significance of Family and Community',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Family and community are fundamental to our happiness and support. They provide love, security, and a sense of belonging. Spending quality time with loved ones strengthens bonds and teaches important values. Being active in our community helps us feel connected and responsible for the common good. Supporting and respecting each other creates a caring environment where everyone can thrive. Together, family and community form the foundation of a happy and harmonious life.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
