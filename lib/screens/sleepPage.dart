import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/sleepDataProvider.dart';
import '../models/sleepChartWidget.dart';
import '../models/weeklySleepChart.dart';

class SleepPage extends StatefulWidget {
  final String day;

  const SleepPage({super.key, required this.day});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  late Future<void> _sleepDataFuture;

  @override
  void initState() {
    super.initState();

    _sleepDataFuture = Future.delayed(Duration.zero, () async {
      final provider = Provider.of<SleepDataProvider>(context, listen: false);
      await provider.fetchSleepData(widget.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Overview')),
      body: FutureBuilder<void>(
        future: _sleepDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final provider = Provider.of<SleepDataProvider>(context);
          final sleepData = provider.sleepData;
          final weeklySummaries = provider.weeklySummaries;

          if (sleepData.isEmpty) {
            return const Center(child: Text("No sleep data available."));
          }

          final dailyData = sleepData.first;
          final formattedDate = DateFormat(
            'yyyy-MM-dd',
          ).format(dailyData.dateOfSleep);

          final totalDuration = weeklySummaries.fold<Duration>(
            Duration.zero,
            (sum, item) => sum + item.duration,
          );

          final average =
              weeklySummaries.isNotEmpty
                  ? totalDuration ~/ weeklySummaries.length
                  : Duration.zero;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sleep on $formattedDate",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SleepBarChart(segments: dailyData.levelsData),

                const SizedBox(height: 32),

                if (weeklySummaries.isNotEmpty) ...[
                  Text(
                    "Andamento settimanale",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: WeeklySleepBarChart(sleepSummaries: weeklySummaries),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Media settimanale: ${average.inHours}h ${average.inMinutes.remainder(60)}m",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
