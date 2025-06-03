import 'package:flutter/material.dart';
import '../services/impact.dart';
import '../models/distancedata.dart';

class DistanceDataProvider extends ChangeNotifier {

  // ------------ DISTANCE DATA ------------

  List<DistanceData> distanceData = [];

  // FETCH DISTANCE DATA DAY
  void fetchDistanceData(String day) async {
    final data = await ImpactRequest.fetchDistanceDataDay(day);

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        distanceData.add(
          DistanceData.fromJson(data['data']['date'], data['data']['data'][i]),
        );
      }

      notifyListeners();
    }
  }

  // FETCH DISTANCE DATA RANGE
  void fetchDistanceDataRange(String startDate, String endDate) async {
    final data = await ImpactRequest.fetchDistanceDataRange(startDate, endDate);

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        final dayData = data['data']['data'][i];
        final date = dayData['date'];
        final values = dayData['data'];

        for (var j = 0; j < values.length; j++) {
          distanceData.add(DistanceData.fromJson(date, values[j]));
        }
      }

      notifyListeners();
    }
  }

  // FETCH on specific periods of times
  double? totalDistanceMonth;
  double? totalDistanceWeek;
  double? totalDistanceDay;

  Future<void> fetchMonthNumDistance() async {
    final data1 = await ImpactRequest.fetchDistanceDataRange("2025-05-19", "2025-05-25");
    final data2 = await ImpactRequest.fetchDistanceDataRange("2025-05-12", "2025-05-18");
    final data3 = await ImpactRequest.fetchDistanceDataRange("2025-05-05", "2025-05-11");
    final data4 = await ImpactRequest.fetchDistanceDataRange("2025-05-01", "2025-05-04");

    final data = [
      ...(data1?['data'] ?? []),
      ...(data2?['data'] ?? []),
      ...(data3?['data'] ?? []),
      ...(data4?['data'] ?? []),
    ];

    double total = 0;
    int dayCount = 0;

    for (var dayData in data) {
      double dayTotal = 0;
      for (var entry in dayData['data']) {
        dayTotal += double.tryParse(entry['value'].toString()) ?? 0.0;
      }
      total += dayTotal;
      dayCount++;
    }

    totalDistanceMonth = dayCount > 0 ? (total / dayCount) /10000 : 0;

    notifyListeners();
  }

  Future<void> fetchWeekNumDistance() async {
    final data = await ImpactRequest.fetchDistanceDataRange("2025-05-19", "2025-05-25");

    if (data != null && data['data'] != null) {
      double total = 0;
      int dayCount = 0;

      for (var dayData in data['data']) {
        double dayTotal = 0;
        for (var entry in dayData['data']) {
          dayTotal += double.tryParse(entry['value'].toString()) ?? 0.0;
        }
        total += dayTotal;
        dayCount++;
      }

      totalDistanceWeek = dayCount > 0 ? (total / dayCount) /10000 : 0;
    } else {
      totalDistanceWeek = 0;
    }

    notifyListeners();
  }

  Future<void> fetchDayNumDistance() async {
    final data = await ImpactRequest.fetchDistanceDataDay("2025-05-25");

    if (data != null && data['data'] != null && data['data']['data'] != null) {
      double total = 0;
      for (var entry in data['data']['data']) {
        total += double.tryParse(entry['value'].toString()) ?? 0.0;
      }

      totalDistanceDay = total/10000; //suppongo sia in cm
    } else {
      totalDistanceDay = 0;
    }

    notifyListeners();
  }

  // Method to clear the "memory"
  void clearData() {
    distanceData.clear();
    notifyListeners();
  }
}
