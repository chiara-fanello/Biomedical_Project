import 'package:flutter/material.dart';

class Lesson2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Value of Education for Peace and Development',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Education is a powerful tool for building peace and promoting development. It helps people understand different cultures, respect diversity, and resolve conflicts peacefully. Educated individuals are more likely to contribute positively to society, find better job opportunities, and help improve their communities. Education also raises awareness about environmental issues, health, and human rights. Ensuring access to quality education for everyone, especially marginalized groups, is crucial for creating a fairer world. Investing in education is investing in a better future, where everyone has the chance to grow, learn, and live in harmony.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
