import 'package:flutter/material.dart';
import '../services/impact.dart';
import '../models/stepdata.dart';

class StepDataProvider extends ChangeNotifier {

  // ------------ STEP DATA ------------

  List<StepData> stepData = [];

  // FETCH STEP DATA DAY
  void fetchStepData(String day) async {

    final data = await ImpactRequest.fetchStepDataDay(day);

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        stepData.add(
            StepData.fromJson(data['data']['date'], data['data']['data'][i]));
      } //for

      notifyListeners();
    }//if

  }//fetchStepData

  // FETCH STEP DATA RANGE
  void fetchStepDataRange(String startDate, String endDate) async {

    
    final data = await ImpactRequest.fetchStepDataRange(startDate, endDate);

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        final dayData = data['data']['data'][i];
        final date = dayData['date'];
        final values = dayData['data'];

        for (var j = 0; j < values.length; j++) {
          stepData.add(StepData.fromJson(date, values[j]));
        }
      }

      notifyListeners();
    }
  }

  // FETCH on specific periods of times
  int? totalStepsMonth;
  int? totalStepsWeek;
  int? totalStepsDay;

  Future<void> fetchMonthNumSteps() async {
    final data1 = await ImpactRequest.fetchStepDataRange("2025-05-19", "2025-05-25");
    final data2 = await ImpactRequest.fetchStepDataRange("2025-05-12", "2025-05-18");
    final data3 = await ImpactRequest.fetchStepDataRange("2025-05-05", "2025-05-11");
    final data4 = await ImpactRequest.fetchStepDataRange("2025-05-01", "2025-05-04");

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

    totalStepsMonth = dayCount > 0 ? (total ~/ dayCount) : 0;

    notifyListeners();
  }

  Future<void> fetchWeekNumSteps() async {
    final data = await ImpactRequest.fetchStepDataRange("2025-05-19", "2025-05-25");

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

      totalStepsWeek = dayCount > 0 ? (total ~/ dayCount) : 0;
    } else {
      totalStepsWeek = 0;
    }

    notifyListeners();
  }

  Future<void> fetchDayNumSteps() async {
    final data = await ImpactRequest.fetchStepDataDay("2025-05-25");

    if (data != null && data['data'] != null && data['data']['data'] != null) {
      int total = 0;
      for (var entry in data['data']['data']) {
        total += int.tryParse(entry['value'].toString()) ?? 0;
      }

      totalStepsDay = total;
    } else {
      totalStepsDay = 0;
    }
    notifyListeners();
  }

  //Method to clear the "memory"
  void clearData() {
    stepData.clear();
    notifyListeners();
  }//clearData
  
}//StepDataProvider