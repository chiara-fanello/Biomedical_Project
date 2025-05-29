import 'package:flutter/material.dart';

class Lesson11 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson11')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Value of Friendship and Solidarity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Friendship and solidarity are fundamental values that help us build a caring and supportive society. True friends listen, support, and respect each other, especially during difficult times. Solidarity means helping others in need, sharing resources, and standing up against injustice. These values foster mutual trust and create a sense of community. Being kind and helpful contributes to a better world where everyone feels valued and accepted. We all can practice friendship and solidarity every day, making a difference in the lives of others.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
