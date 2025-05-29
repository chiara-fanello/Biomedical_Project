import 'package:flutter/material.dart';

class Lesson4 extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson4')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' The Role of Culture and Diversity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Culture and diversity are treasures that enrich our societies. They include traditions, languages, arts, and beliefs that make each community unique. Embracing diversity fosters understanding, tolerance, and mutual respect among people from different backgrounds. It also encourages creativity and innovation, as different perspectives come together. Preserving cultural heritage helps maintain our identity and history. In our interconnected world, learning about other cultures broadens horizons and promotes peaceful coexistence. Celebrating diversity is essential for building a harmonious society where everyone feels valued and accepted.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
