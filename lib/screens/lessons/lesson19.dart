import 'package:flutter/material.dart';

class Lesson19 extends StatelessWidget {
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
              'The Importance of Respecting Nature',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Respecting nature means taking care of the environment and all living things. Simple actions like not littering, saving water, and protecting animals help preserve Earth''s beauty and resources. Nature provides us with air, water, food, and a home for many species. When we respect nature, we ensure a healthy planet for ourselves and future generations. Everyone can contribute by being environmentally conscious in their daily choices.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
