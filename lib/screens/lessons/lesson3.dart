import 'package:flutter/material.dart';

class Lesson3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson3')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Power of Non-Violence and Dialogue',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Non-violence and dialogue are essential principles for resolving conflicts peacefully. Instead of violence, dialogue encourages listening, understanding, and finding common solutions. Leaders like Mahatma Gandhi and Martin Luther King Jr. showed how non-violent resistance can bring about social change. Promoting dialogue helps build trust and respect among different communities, reducing hatred and division. Teaching young people the value of peaceful communication prepares them to be responsible citizens. When we choose dialogue over violence, we contribute to a safer, more respectful, and more just society for everyone.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
