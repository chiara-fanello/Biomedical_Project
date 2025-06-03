import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/distanceDataProvider.dart'; // Assicurati che il provider esista

class DistancePage extends StatefulWidget {
  @override
  _DistancePageState createState() => _DistancePageState();
}

class _DistancePageState extends State<DistancePage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DistanceDataProvider>(context, listen: false);

    provider.fetchDayNumDistance();
    provider.fetchWeekNumDistance();
    provider.fetchMonthNumDistance();
    print(provider.totalDistanceMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DISTANCE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<DistanceDataProvider>(
          builder: (context, distanceProvider, child) {
            final dayDistance = distanceProvider.totalDistanceDay ?? 0.0;
            final weekDistance = distanceProvider.totalDistanceWeek ?? 0.0;
            final monthDistance = distanceProvider.totalDistanceMonth ?? 0.0;

            String message = '';
            if (dayDistance < 1.0) {
              message = 'Let\'s go for a short walk!';
            } else if (dayDistance < 3.0) {
              message = 'Daily walk completed. Now start working out harder!';
            } else if (dayDistance < 8.0) {
              message = 'Great job. You got up on the right foot!';
            } else if (dayDistance < 15.0) {
              message = 'Keep it up, and soon you will be able to participate in the New York Half Marathon';
            }else {
              message = "You're doing great! Watch out for lactic acid";
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DistanceBox(title: 'Daily distance (km)', distance: dayDistance),
                SizedBox(height: 12),
                DistanceBox(title: 'Avg weekly distance (km)', distance: weekDistance),
                SizedBox(height: 12),
                DistanceBox(title: 'Avg monthly distance (km)', distance: monthDistance),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green),
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

class DistanceBox extends StatelessWidget {
  final String title;
  final double distance;

  const DistanceBox({required this.title, required this.distance});

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
          Text('${distance.toStringAsFixed(2)} km',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
