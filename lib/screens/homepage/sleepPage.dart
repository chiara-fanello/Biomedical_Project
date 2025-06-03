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
        await sleepProvider.fetchSleepData();
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

  // Tutto il resto (import, class SleepPage, ecc.) rimane invariato fino al build

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
          String stressLevel = "Basso";
          if (restingHRValue > 65 && average.inHours < 6) {
            stressLevel = "Alto";
          } else if (restingHRValue > 60 || average.inHours < 6) {
            stressLevel = "Moderato";
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trend del sonno",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Data: $formattedDate",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),

                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: SleepBarChart(segments: dailyData.levelsData),
                ),

                const SizedBox(height: 0),
                if (weeklySummaries.isNotEmpty) ...[
                  Text(
                    "Andamento settimanale",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: WeeklySleepBarChart(sleepSummaries: weeklySummaries),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "On average over the past seven days, you slept for:  ${average.inHours}h ${average.inMinutes.remainder(60)}m",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Text(
                  "Dati fisiologici",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                RestingHeartRateCard(restingHeartRate: restingHRValue),
                const SizedBox(height: 16), // Spazio per futura Card

                const SizedBox(height: 16),
                Text(
                  "Stress Level",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                StressLevelCard(level: stressLevel),
                const SizedBox(height: 16), // Spazio
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
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
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

class StressLevelCard extends StatelessWidget {
  final String level;

  const StressLevelCard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (level) {
      case "High":
        color = Colors.redAccent;
        icon = Icons.warning;
        break;
      case "Moderate":
        color = Colors.orange;
        icon = Icons.error_outline;
        break;
      default:
        color = const Color(0xFF2E7D32); // Verde più vivido
        icon = Icons.check_circle_outline;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Stress Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
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
