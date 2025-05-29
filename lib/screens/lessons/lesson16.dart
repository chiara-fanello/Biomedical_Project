import 'package:flutter/material.dart';

class Lesson16 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson16')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Importance of Environmental Protection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Protecting the environment is vital for our health and future. Simple actions like recycling, saving water, and reducing plastic use help preserve natural resources. Planting trees and supporting conservation projects also make a difference. Pollution and deforestation threaten ecosystems and climate stability. Each of us can contribute by making eco-friendly choices and raising awareness. Taking care of our planet ensures a cleaner, healthier world for ourselves and future generations.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
