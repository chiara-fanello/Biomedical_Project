import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../provider/sleepDataProvider.dart';
import '../../provider/rhrDataProvider.dart';
import '../../models/weeklySleepChart.dart';
import '../../models/sleepChartWidget.dart';

class SleepPage extends StatefulWidget {
  final String day;

  const SleepPage({super.key, required this.day});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  late Future<void> _dataFuture;

  @override
  void initState() {
    super.initState();

    final selectedDay = DateTime.parse(widget.day);
    final startDate = selectedDay.subtract(const Duration(days: 6));
    final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endDateStr = DateFormat('yyyy-MM-dd').format(selectedDay);

    _dataFuture = Future.wait([
      Future(() async {
        final sleepProvider = Provider.of<SleepDataProvider>(
          context,
          listen: false,
        );
        await sleepProvider.fetchSleepData(widget.day);
        await sleepProvider.fetchSleepDataRange(startDateStr, endDateStr);
      }),
      Future(() async {
        final hrProvider = Provider.of<RestingHeartRateProvider>(
          context,
          listen: false,
        );
        await hrProvider.fetchRestingHeartRate(widget.day);
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Overview')),
      body: FutureBuilder<void>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sleepProvider = Provider.of<SleepDataProvider>(context);
          final hrProvider = Provider.of<RestingHeartRateProvider>(context);
          final sleepData = sleepProvider.sleepData;
          final weeklySummaries = sleepProvider.weeklySummaries;

          if (sleepData.isEmpty) {
            return const Center(child: Text("No sleep data available."));
          }

          // Calcolo media battito cardiaco a riposo (se dati disponibili)
          final restingHR = hrProvider.restingHeartRate;
          double restingHRValue = 0;
          if (restingHR != null && restingHR.data.isNotEmpty) {
            final sum = restingHR.data
                .map((e) => e.value)
                .reduce((a, b) => a + b);
            restingHRValue = sum / restingHR.data.length;
          }

          final dailyData = sleepData.first;
          final formattedDate = DateFormat(
            'yyyy-MM-dd',
          ).format(dailyData.dateOfSleep);

          final totalDuration = weeklySummaries.fold<Duration>(
            Duration.zero,
            (sum, item) => sum + item.totalSleep,
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
                RichText(
                  text: TextSpan(
                    text: "Sleep trend on ",
                    style: Theme.of(context).textTheme.titleLarge,
                    children: [
                      TextSpan(
                        text: formattedDate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                SleepBarChart(segments: dailyData.levelsData),
                const SizedBox(height: 16),
                if (weeklySummaries.isNotEmpty) ...[
                  Text(
                    "Andamento settimanale",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: WeeklySleepBarChart(sleepSummaries: weeklySummaries),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Media settimanale: ${average.inHours}h ${average.inMinutes.remainder(60)}m",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  // Widget per battito cardiaco a riposo
                  RestingHeartRateCard(restingHeartRate: restingHRValue),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class RestingHeartRateCard extends StatelessWidget {
  final double restingHeartRate;

  const RestingHeartRateCard({super.key, required this.restingHeartRate});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(Icons.favorite, color: Colors.redAccent, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battito cardiaco a riposo',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    restingHeartRate > 0
                        ? '${restingHeartRate.toStringAsFixed(0)} bpm'
                        : 'Dati non disponibili',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
