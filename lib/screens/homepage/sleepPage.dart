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

          ///////////////////////////////////////
          /// IF PER CHIARA
          ///                ///
          ///               ///
          ///               ///
          ///               ///

          final lastNightDuration = sleepProvider.getLastNightSleepDuration();
          String sleepQualityMessage = "Durata sonno non disponibile";
          if (lastNightDuration != null) {
            if (lastNightDuration.inHours >= 8) {
              sleepQualityMessage = "Hai dormito a lungo! Ottimo riposo!";
            } else if (lastNightDuration.inHours >= 6) {
              sleepQualityMessage = "Durata del sonno nella media.";
            } else {
              sleepQualityMessage =
                  "Hai dormito poco, cerca di riposare di più.";
            }
          }

          final dailyData =
              sleepData.isNotEmpty ? sleepData.first : SleepData.empty();

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
          // Crea lista di 7 giorni della settimana con sonno, riempiendo i buchi con zero
          List<WeeklySleepSummary> completedWeek(
            List<WeeklySleepSummary> originalSummaries,
            String referenceDay,
          ) {
            final manualDate = DateTime.parse(day);
            final startOfWeek = manualDate.subtract(
              Duration(days: manualDate.weekday - 1),
            );
            final Map<String, WeeklySleepSummary> map = {
              for (var e in originalSummaries)
                DateFormat('yyyy-MM-dd').format(e.date): e,
            };

            return List.generate(7, (index) {
              final date = startOfWeek.add(Duration(days: index));
              final key = DateFormat('yyyy-MM-dd').format(date);
              return map[key] ??
                  WeeklySleepSummary(date: date, totalSleep: Duration.zero);
            });
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
                                'Analisi durata del sonno',
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
                    child: WeeklySleepBarChart(
                      sleepSummaries: completedWeek(weeklySummaries, day),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "In media negli ultimi 7 giorni hai dormito: ${average.inHours}h ${average.inMinutes.remainder(60)}m",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                Text(
                  "Dati fisiologici",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                RestingHeartRateCard(restingHeartRate: restingHRValue),

                const SizedBox(height: 24),
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
      case "Alto":
        color = Colors.redAccent;
        icon = Icons.warning;
        break;
      case "Moderato":
        color = Colors.orange;
        icon = Icons.error_outline;
        break;
      default:
        color = const Color(0xFF2E7D32);
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
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
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
