import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/sleepdata.dart';
import 'package:provider/provider.dart';
import '../../provider/sleepDataProvider.dart';
import '../../provider/rhrDataProvider.dart';
import '../../models/weeklySleepChart.dart';
import '../../models/sleepChartWidget.dart';

class SleepPage extends StatelessWidget {
  final String day;
  const SleepPage({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Overview')),
      body: Consumer2<SleepDataProvider, RestingHeartRateProvider>(
        builder: (context, sleepProvider, hrProvider, _) {
          final sleepData = sleepProvider.sleepData;
          final weeklySummaries = sleepProvider.weeklySummaries;

          // Debugging: print original weekly summaries
          print('Checking for issues with weekly summaries:');
          for (var summary in weeklySummaries) {
            print(summary);
          }

          /// IF FOR CHIARA ///
          ///                ///
          ///                ///
          ///                ///

          // Analyze last night's sleep duration
          final lastNightDuration = sleepProvider.getLastNightSleepDuration();
          String sleepQualityMessage = "Sleep duration not available";
          if (lastNightDuration != null) {
            if (lastNightDuration.inHours < 4) {
              sleepQualityMessage =
                  "Your body is asking for help — even lions rest before they hunt.";
            } else if (lastNightDuration.inHours < 5) {
              sleepQualityMessage =
                  "Enduring isn't strength. Recovering is power.";
            } else if (lastNightDuration.inHours < 6) {
              sleepQualityMessage =
                  "You're not a machine. Sleep to shine while awake.";
            } else if (lastNightDuration.inHours < 7) {
              sleepQualityMessage =
                  "The foundation is there. Now level up — even in rest.";
            } else if (lastNightDuration.inHours < 8) {
              sleepQualityMessage =
                  "Recharged, centered, ready. Rest makes you unstoppable.";
            } else if (lastNightDuration.inHours < 9) {
              sleepQualityMessage =
                  "When sleep runs deep, dreams turn into plans.";
            } else {
              sleepQualityMessage =
                  "Today you chose to heal. Rest is invisible training.";
            }
          }

          // Get data for a specific day (used for bar chart)
          final dailyData =
              sleepData.isNotEmpty ? sleepData.first : SleepData.empty();

          // Calculate average resting heart rate
          final restingHR = hrProvider.restingHeartRate;
          double restingHRValue = 0;
          if (restingHR != null && restingHR.data.isNotEmpty) {
            final sum = restingHR.data
                .map((e) => e.value)
                .reduce((a, b) => a + b);
            restingHRValue = sum / restingHR.data.length;
          }

          final formattedDate = DateFormat(
            'yyyy-MM-dd',
          ).format(dailyData.dateOfSleep);

          // Compute weekly sleep average
          final totalDuration = weeklySummaries.fold<Duration>(
            Duration.zero,
            (sum, item) => sum + item.totalSleep,
          );
          final average =
              weeklySummaries.isNotEmpty
                  ? totalDuration ~/ weeklySummaries.length
                  : Duration.zero;

          // Estimate stress level based on average sleep and resting HR
          String stressLevel = "Low";
          if (restingHRValue > 65 && average.inHours < 6) {
            stressLevel = "High";
          } else if (restingHRValue > 60 || average.inHours < 6) {
            stressLevel = "Moderate";
          }

          // Complete the weekly data with empty entries where missing
          List<WeeklySleepSummary> completedWeek(
            List<WeeklySleepSummary> originalSummaries,
            String referenceDay,
          ) {
            final manualDate = DateTime.parse(referenceDay);
            final dateFormat = DateFormat('yyyy-MM-dd');

            // Map of existing data entries
            final Map<String, WeeklySleepSummary> map = {
              for (var e in originalSummaries)
                dateFormat
                    .format(DateTime(e.date.year, e.date.month, e.date.day)): e,
            };

            // Build a 7-day list ending with the reference day
            final List<WeeklySleepSummary> completed = [];

            for (int i = 6; i >= 0; i--) {
              final date = manualDate.subtract(Duration(days: i));
              final key = dateFormat.format(date);
              if (map.containsKey(key)) {
                completed.add(map[key]!);
              } else {
                completed.add(
                  WeeklySleepSummary(date: date, totalSleep: Duration.zero),
                );
              }
            }

            return completed;
          }

          final completedWeekData = completedWeek(weeklySummaries, day);

          // Debugging: print completed weekly data
          print("Completed weekly data:");
          for (var w in completedWeekData) {
            print(
              "${DateFormat('yyyy-MM-dd').format(w.date)}: ${w.totalSleep.inMinutes} min",
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sleep Trend",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Date: $formattedDate",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: SleepBarChart(segments: dailyData.levelsData),
                ),

                // Sleep Quality Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bedtime, color: Colors.blueAccent, size: 36),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sleep Duration Analysis',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                sleepQualityMessage,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Weekly sleep trend
                if (weeklySummaries.isNotEmpty) ...[
                  Text(
                    "Weekly Trend",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: WeeklySleepBarChart(
                      sleepSummaries: completedWeekData,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Average sleep over last 7 days: ${average.inHours}h ${average.inMinutes.remainder(60)}m",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Physiological data
                Text(
                  "Physiological Data",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                RestingHeartRateCard(restingHeartRate: restingHRValue),

                const SizedBox(height: 24),

                // Stress estimation
                Text(
                  "Stress Level",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                StressLevelCard(level: stressLevel),
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
                    'Resting heart rate',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    restingHeartRate > 0
                        ? '${restingHeartRate.toStringAsFixed(0)} bpm'
                        : 'Data not available',
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
    // Define base background and foreground (text/icon) colors
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (level) {
      case "High":
        backgroundColor = const Color(0xFFFFE0E0);
        textColor = const Color(0xFFB00020);
        icon = Icons.warning_amber_rounded;
        break;

      case "Moderate":
        backgroundColor = const Color(0xFFFFF3D9);
        textColor = const Color(0xFF996515);
        icon = Icons.error_outline;
        break;

      default: // Low
        backgroundColor = const Color(0xFFE4F4EA);
        textColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle_outline;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Stress Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w900,
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
