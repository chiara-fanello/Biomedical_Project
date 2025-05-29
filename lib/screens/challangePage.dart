import 'package:flutter/material.dart';
import 'lessons/lesson1.dart';
import 'lessons/lesson10.dart';
import 'lessons/lesson11.dart';
import 'lessons/lesson12.dart';
import 'lessons/lesson13.dart';
import 'lessons/lesson14.dart';
import 'lessons/lesson15.dart';
import 'lessons/lesson16.dart';
import 'lessons/lesson17.dart';
import 'lessons/lesson18.dart';
import 'lessons/lesson19.dart';
import 'lessons/lesson2.dart';
import 'lessons/lesson20.dart';
import 'lessons/lesson3.dart';
import 'lessons/lesson4.dart';
import 'lessons/lesson5.dart';
import 'lessons/lesson6.dart';
import 'lessons/lesson7.dart';
import 'lessons/lesson8.dart';
import 'lessons/lesson9.dart';

class Challangepage extends StatelessWidget{

  final int active_lesson = 0;

  final int itemCount = 40;

    final List<Widget> _pages = [
    Lesson1(),
    Lesson2(),
    Lesson3(),
    Lesson4(),
    Lesson5(),
    Lesson6(),
    Lesson7(),
    Lesson8(),
    Lesson9(),
    Lesson10(),
    Lesson11(),
    Lesson12(),
    Lesson13(),
    Lesson14(),
    Lesson15(),
    Lesson16(),
    Lesson17(),
    Lesson18(),
    Lesson19(),
    Lesson20(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challanges and Lessons'),
      ),
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // Alterna tra sfida e lezione
          bool isChallenge = index % 2 == 0;
          String title = isChallenge ? 'Challange ${index ~/ 2}' : 'Lesson ${index ~/ 2 + 1}';

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if(!isChallenge){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:  (context) => _pages[index ~/ 2]
                    ),
                  );
                }
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: isChallenge ? const Color.fromARGB(255, 255, 165, 110) : const Color.fromARGB(255, 104, 232, 123),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


