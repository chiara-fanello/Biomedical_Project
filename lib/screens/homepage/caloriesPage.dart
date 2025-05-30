import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/caloriesDataProvider.dart';

class CaloriesPage extends StatefulWidget {
  @override
  _CaloriesPageState createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CaloriesDataProvider>(context, listen: false);

    provider.fetchDayNumCalories();
    provider.fetchWeekNumCalories();
    provider.fetchMonthNumCalories();
    print(provider.totalCaloriesMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CALORIES'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CaloriesDataProvider>(
          builder: (context, caloriesProvider, child) {
            final dayCalories = caloriesProvider.totalCaloriesDay ?? 0;
            final weekCalories = caloriesProvider.totalCaloriesWeek ?? 0;
            final monthCalories = caloriesProvider.totalCaloriesMonth ?? 0;

            String message = '';
            if (dayCalories < 500) {
              message = 'You should burn more calories today!';
            } else if (dayCalories < 1500) {
              message = 'Nice effort, keep moving!';
            } else if (dayCalories < 3000) {
              message = 'Great job, you’re staying active!';
            } else {
              message = 'You are unstoppable!';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CaloriesBox(title: 'Daily calories', calories: dayCalories),
                SizedBox(height: 12),
                CaloriesBox(title: 'Avg weekly calories', calories: weekCalories),
                SizedBox(height: 12),
                CaloriesBox(title: 'Avg monthly calories', calories: monthCalories),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange),
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

class CaloriesBox extends StatelessWidget {
  final String title;
  final int calories;

  const CaloriesBox({required this.title, required this.calories});

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
          Text('$calories',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
