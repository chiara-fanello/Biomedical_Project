import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepSummary {
  final String label;
  final Duration duration;

  SleepSummary({required this.label, required this.duration});
}

class WeeklySleepBarChart extends StatelessWidget {
  final List<SleepSummary> sleepSummaries;

  const WeeklySleepBarChart({super.key, required this.sleepSummaries});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround, // Evenly distributes bars
        maxY: 12, // Maximum hours displayed (e.g. 12h)
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                return Text(
                  "${value.toInt()}h", // Y-axis labels in hours
                  style: const TextStyle(fontSize: 10),
                );
              },
              interval: 2, // Interval every 2 hours
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= sleepSummaries.length) {
                  return const SizedBox(); // Hide labels if index is out of range
                }
                return Text(
                  sleepSummaries[index].label, // e.g., Mon, Tue, etc.
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        barGroups:
            sleepSummaries.asMap().entries.map((entry) {
              final index = entry.key;
              final summary = entry.value;
              final hours = summary.duration.inMinutes / 60;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: hours,
                    color: Colors.blueAccent,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
        gridData: FlGridData(show: false), // Do not show horizontal grid lines
        borderData: FlBorderData(show: false), // No border around the chart
      ),
    );
  }
}
