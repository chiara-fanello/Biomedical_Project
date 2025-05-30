import 'package:flutter/material.dart';
import '../services/impact.dart';
import '../models/caloriesdata.dart'; // Presumibilmente rinominato anche il model

class CaloriesDataProvider extends ChangeNotifier {

  // ------------ CALORIES DATA ------------

  List<CaloriesData> caloriesData = [];

  // FETCH CALORIES DATA DAY
  void fetchCaloriesData(String day) async {

    final data = await ImpactRequest.fetchCaloriesDataDay(day);

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        caloriesData.add(
            CaloriesData.fromJson(data['data']['date'], data['data']['data'][i]));
      }

      notifyListeners();
    }
  }

  // FETCH CALORIES DATA RANGE
  void fetchCaloriesDataRange(String startDate, String endDate) async {
    final data = await ImpactRequest.fetchCaloriesDataRange(startDate, endDate);

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        final dayData = data['data']['data'][i];
        final date = dayData['date'];
        final values = dayData['data'];

        for (var j = 0; j < values.length; j++) {
          caloriesData.add(CaloriesData.fromJson(date, values[j]));
        }
      }

      notifyListeners();
    }
  }

  // FETCH on specific periods of times
  int? totalCaloriesMonth;
  int? totalCaloriesWeek;
  int? totalCaloriesDay;

  Future<void> fetchMonthNumCalories() async {
    final data1 = await ImpactRequest.fetchCaloriesDataRange("2025-05-19", "2025-05-25");
    final data2 = await ImpactRequest.fetchCaloriesDataRange("2025-05-12", "2025-05-18");
    final data3 = await ImpactRequest.fetchCaloriesDataRange("2025-05-05", "2025-05-11");
    final data4 = await ImpactRequest.fetchCaloriesDataRange("2025-05-01", "2025-05-04");

    final data = [
      ...(data1?['data'] ?? []),
      ...(data2?['data'] ?? []),
      ...(data3?['data'] ?? []),
      ...(data4?['data'] ?? []),
    ];

    int total = 0;
    int dayCount = 0;

    for (var dayData in data) {
      int dayTotal = 0;
      for (var entry in dayData['data']) {
        dayTotal += int.tryParse(entry['value'].toString()) ?? 0;
      }
      total += dayTotal;
      dayCount++;
    }

    totalCaloriesMonth = dayCount > 0 ? (total ~/ dayCount) : 0;

    notifyListeners();
  }

  Future<void> fetchWeekNumCalories() async {
    final data = await ImpactRequest.fetchCaloriesDataRange("2025-05-19", "2025-05-25");

    if (data != null && data['data'] != null) {
      int total = 0;
      int dayCount = 0;

      for (var dayData in data['data']) {
        int dayTotal = 0;
        for (var entry in dayData['data']) {
          dayTotal += int.tryParse(entry['value'].toString()) ?? 0;
        }
        total += dayTotal;
        dayCount++;
      }

      totalCaloriesWeek = dayCount > 0 ? (total ~/ dayCount) : 0;
    } else {
      totalCaloriesWeek = 0;
    }

    notifyListeners();
  }

  Future<void> fetchDayNumCalories() async {
    final data = await ImpactRequest.fetchCaloriesDataDay("2025-05-25");

    if (data != null && data['data'] != null && data['data']['data'] != null) {
      int total = 0;
      for (var entry in data['data']['data']) {
        total += int.tryParse(entry['value'].toString()) ?? 0;
      }

      totalCaloriesDay = total;
    } else {
      totalCaloriesDay = 0;
    }
    notifyListeners();
  }

  //Method to clear the "memory"
  void clearData() {
    caloriesData.clear();
    notifyListeners();
  }

} // CaloriesDataProvider
