import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/goalsProvider.dart';
import 'package:provider/provider.dart';
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

class Challengepage extends StatelessWidget {
  final int itemCount = 20;

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
    int lessons = Provider.of<GoalsProvider>(context).lessons();
    return Scaffold(
      appBar: AppBar(title: Text('Lessons')),
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          String title = 'Lesson ${index + 1}';
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (lessons > index) {  // Lesson lock if the objective has not yet been completed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => _pages[index]),
                  );
                }
              },
              child: Row(   // Lesson box creation + lock/unlock status
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color:Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            Provider.of<GoalsProvider>(
                              context,
                              listen: false,
                            ).getGoalString(index + 1),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    lessons > index
                        ? Icons.lock_open_outlined
                        : Icons.lock,
                    size: 24,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
