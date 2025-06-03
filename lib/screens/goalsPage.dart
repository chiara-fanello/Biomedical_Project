import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/goalsProvider.dart';
import 'package:provider/provider.dart';

class GoalsPage extends StatefulWidget {
  final int id;
  const GoalsPage({Key? key, required this.id}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  bool pressed = false; 

  @override
  Widget build(BuildContext context) {
    final activeLesson = Provider.of<GoalsProvider>(context).lessons();
    String goalDescription = Provider.of<GoalsProvider>(
      context,
      listen: false,
    ).getGoalString(widget.id);

    return Scaffold(
      appBar: AppBar(title: Text('Goal #${widget.id}')),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goalDescription,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '"Self-analysis: reflect on the past few days. Have you achieved this goal?"',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.id == activeLesson + 1) {
                  Provider.of<GoalsProvider>(
                    context,
                    listen: false,
                  ).setLessonsPassed();
                }
                setState(() {
                  pressed = true; 
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),

              child: Text(''), 
            ),
            SizedBox(height: 20),
            if (pressed)
              Text(
                'Congratulation! Goal completed!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}