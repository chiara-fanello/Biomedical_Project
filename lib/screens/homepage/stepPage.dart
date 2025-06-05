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

            // Calcolo CO₂ risparmiata
            final double stepLengthMeters = 0.4;
            final double distanceKm = (daySteps * stepLengthMeters) / 1000;
            final double co2PerKm = 115; // grammi/km
            final double co2Saved = distanceKm * co2PerKm;

            String message = '';
            if (daySteps < 3000) {
              message = 'Your story hasn’t started yet. Get up, move, and make today count.';
            } else if (daySteps < 5000) {
              message = 'You’ve taken a few steps. Now keep the fire alive—your best self is waiting';
            } else if (daySteps < 8000) {
              message = 'Momentum is building. You’re walking toward a stronger you.';
            } else if(daySteps < 11000){
              message = 'You’re unstoppable. You’ve moved your body, and your mind followed.';
            } else if(daySteps < 15000){
              message = 'You\'re fierce. Energy, focus, and fire in motion.';
            } else {
              message = 'You are a force of nature. Tireless, relentless, alive.';
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StepBox(title: 'Daily steps', steps: daySteps),
                  SizedBox(height: 12),
                  StepBox(title: 'Avg weekly steps', steps: weekSteps),
                  SizedBox(height: 12),
                  StepBox(title: 'Avg monthly steps', steps: monthSteps),
                  SizedBox(height: 24),
                  _InfoBox(
                    color: Colors.blue.shade50,
                    borderColor: Colors.blue,
                    text: message,
                  ),
                  SizedBox(height: 16),
                  _InfoBox(
                    color: Colors.green.shade50,
                    borderColor: Colors.green,
                    text:
                        'Estimated CO₂ saved by walking today compared to a car travel: \n ${co2Saved.toStringAsFixed(2)} g',
                  ),
                ],
              ),
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

class _InfoBox extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String text;

  const _InfoBox({
    required this.color,
    required this.borderColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
