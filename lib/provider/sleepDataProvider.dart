import 'package:flutter/material.dart';
import '../models/sleepdata.dart';
import '../services/impact.dart';

class SleepDataProvider extends ChangeNotifier {
  List<SleepData> sleepData = [];
  List<WeeklySleepSummary> weeklySummaries = [];

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

        notifyListeners();
        print('Sleep data loaded successfully');
      } catch (e) {
        print('Error parsing SleepData: $e');
      }
    } else {
      print('Invalid or incomplete response');
    }
  }

  String? getLastNightSleepDurationString() {
    if (sleepData.isEmpty) return null;

    final lastNight = sleepData.last;

    if (lastNight.levelsData.isEmpty) return null;

    final totalDuration = lastNight.levelsData.fold<Duration>(
      Duration.zero,
      (sum, segment) => sum + segment.duration,
    );

    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes % 60;

    return "${hours}h ${minutes.toString().padLeft(2, '0')}m";
  }

  Duration? getLastNightSleepDuration() {
    if (sleepData.isEmpty) return null;
    final lastNight = sleepData.last;
    if (lastNight.levelsData.isEmpty) return null;

    return lastNight.levelsData.fold<Duration>(
      Duration.zero,
      (sum, segment) => sum + segment.duration,
    );
  }

  Future<void> fetchSleepDataRange(String startDate, String endDate) async {
    try {
      final data = await ImpactRequest.fetchSleepDataRange(startDate, endDate);
      if (data != null) {
        weeklySummaries = parseWeeklySleepData(data);
        notifyListeners();
      } else {
        print('fetchSleepDataRange returned null');
      }
    } catch (e, stack) {
      print('Error fetching or parsing weekly sleep data: $e');
      print(stack);
    }
  }
}
