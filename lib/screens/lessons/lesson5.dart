import 'package:flutter/material.dart';

class Lesson5 extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson5')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Responsibility of Each One of Us for a Sustainable Future',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Building a sustainable future requires the active participation of everyone—individuals, communities, governments, and businesses. Simple actions, like saving energy, reducing waste, and choosing eco-friendly products, can make a big difference. Protecting natural environments, conserving water, and supporting renewable energy are vital steps. Each of us has a responsibility to think about the impact of our choices on the planet. Educating ourselves and others about sustainability helps create a culture of respect for nature. Together, we can build a world where development meets environmental protection, ensuring a healthy planet for future generations.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
