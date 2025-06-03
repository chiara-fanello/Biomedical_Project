import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'sleepdata.dart';

class WeeklySleepBarChart extends StatelessWidget {
  final List<WeeklySleepSummary> sleepSummaries;

  const WeeklySleepBarChart({super.key, required this.sleepSummaries});

  String formatDurationAsHHmm(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return "$h-$m";
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 9,
        minY: 0,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3, // <-- ogni 3 ore
              getTitlesWidget: (value, _) {
                return Text("${value.toInt()}h");
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= sleepSummaries.length) {
                  return const SizedBox();
                }
                final date = sleepSummaries[index].date;
                final dayLabel = DateFormat.E('it').format(date);
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    dayLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ), // niente titoli sopra
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ), // niente titoli a destra
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 3, // griglia ogni 3 ore per allineare con Y
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.grey),
            bottom: BorderSide(color: Colors.grey),
            top: BorderSide(color: Colors.transparent),
            right: BorderSide(color: Colors.transparent),
          ),
        ),
        barGroups:
            sleepSummaries.asMap().entries.map((entry) {
              final index = entry.key;
              final summary = entry.value;

              final hours = summary.totalSleep.inMinutes / 60;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: hours,
                    width: 22,
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade700],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ],
              );
            }).toList(),
        barTouchData: BarTouchData(
          enabled: false,
          handleBuiltInTouches: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blue.shade700.withOpacity(0.85),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final duration = sleepSummaries[group.x].totalSleep;
              final formatted = formatDurationAsHHmm(duration);
              return BarTooltipItem(
                "$formatted",
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
