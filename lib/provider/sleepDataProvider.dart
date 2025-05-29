import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sleepdata.dart';
import '../services/impact.dart';
import '../models/weeklySleepChart.dart';

class SleepDataProvider extends ChangeNotifier {
  List<SleepData> sleepData = [];
  List<SleepSummary> weeklySummaries = [];

  Future<void> fetchSleepData(String day) async {
    final data = await ImpactRequest.fetchSleepData(day);
    print('Received data for day $day:\n$data');

    if (data != null && data['status'] == 'success' && data['data'] != null) {
      final dateStr = data['data']['date'];
      final year = dateStr.substring(0, 4);
      final inner = data['data']['data'];

      if (inner == null) {
        print('No sleep data available for day $day');
        return;
      }

      try {
        sleepData.clear(); // Only daily data
        final sleep = SleepData.fromJson(inner, year);
        sleepData.add(sleep);

        // Update the weekly summary chart
        _updateWeeklySummary(sleep);

        notifyListeners();
        print('Sleep data loaded successfully');
      } catch (e) {
        print('Error parsing SleepData: $e');
      }
    } else {
      print('Invalid or incomplete response');
    }
  }

  void _updateWeeklySummary(SleepData data) {
    final segments = data.levelsData;
    if (segments.isEmpty) return;

    final duration = segments.last.end.difference(segments.first.start);
    final label = DateFormat(
      'EEE dd/MM',
    ).format(data.dateOfSleep); // unique day label

    final summary = SleepSummary(label: label, duration: duration);

    // Avoid exact duplicates
    weeklySummaries.removeWhere((s) => s.label == label);
    weeklySummaries.add(summary);

    // Keep at most 7 recent entries
    if (weeklySummaries.length > 7) {
      weeklySummaries.removeAt(0);
    }

    // (Optional) Sort by label/date
    weeklySummaries.sort((a, b) => a.label.compareTo(b.label));
  }

  void clearData() {
    print('Clearing only sleepData, NOT weeklySummaries');
    sleepData.clear();
    notifyListeners();
  }

  List<SleepSummary> getWeeklySummaries() => weeklySummaries;
}
