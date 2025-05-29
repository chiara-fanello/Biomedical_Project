import 'package:flutter/material.dart';

class Lesson1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson1')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Importance of Healthy Eating and Active Lifestyle',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Maintaining a healthy diet and staying active are essential for well-being. Eating a variety of fruits, vegetables, and whole grains helps our body stay strong and fight illnesses. Regular physical activity, like walking, sports, or dancing, improves our heart, muscles, and mind. Healthy habits from a young age can prevent many diseases and promote better concentration and mood. It’s important to avoid excessive sugar, salt, and junk food. Leading a balanced lifestyle benefits not only our health but also contributes to a happier and more energetic life.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
