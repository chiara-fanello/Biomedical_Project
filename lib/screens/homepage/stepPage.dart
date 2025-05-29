import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/stepDataProvider.dart';

class StepPage extends StatefulWidget {
  @override
  _StepPageState createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<StepDataProvider>(context, listen: false);

    provider.fetchDayNumSteps();
    provider.fetchWeekNumSteps();
    provider.fetchMonthNumSteps();
    print(provider.totalStepsMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STEPS'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StepDataProvider>(
          builder: (context, stepProvider, child) {
            final daySteps = stepProvider.totalStepsDay ?? 0;
            final weekSteps = stepProvider.totalStepsWeek ?? 0;
            final monthSteps = stepProvider.totalStepsMonth ?? 0;

            String message = '';
            if (daySteps < 1000) {
              message = 'Walk a little is good for your health'; 
            } else if (daySteps < 5000) {
              message = 'trallalero trallalà'; 
            } else if (daySteps < 10000) {
              message = 'You walked enough, rest a little!'; 
            } else {
              message = 'tung tung tung saur'; 
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepBox(title: 'Daily steps', steps: daySteps),
                SizedBox(height: 12),
                StepBox(title: 'Weekly steps', steps: weekSteps),
                SizedBox(height: 12),
                StepBox(title: 'Monthly steps', steps: monthSteps),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class StepBox extends StatelessWidget {
  final String title;
  final int steps;

  const StepBox({required this.title, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87)),
          SizedBox(height: 8),
          Text('$steps',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
