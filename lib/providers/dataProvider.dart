import 'package:flutter/material.dart';
import '../services/impact.dart';
import '../models/stepData.dart';

class DataProvider extends ChangeNotifier {

  // ------------ STEP DATA ------------

  List<StepData> stepData = [];

  // FETCH STEP DATA DAY
  void fetchStepData(String day) async {

    //Get the response
    final data = await ImpactRequest.fetchStepDataDay(day);

    //if OK parse the response adding all the elements to the list, otherwise do nothing
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        stepData.add(
            StepData.fromJson(data['data']['date'], data['data']['data'][i]));
      } //for

      //remember to notify the listeners
      notifyListeners();
    }//if

  }//fetchStepData

  // FETCH STEP DATA RANGE
  void fetchStepDataRange(String startDate, String endDate) async {

    // Get the response
    final data = await ImpactRequest.fetchStepDataRange(startDate, endDate);

    // if OK parse the response and add all elements to the list
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
    final data = await ImpactRequest.fetchStepDataRange("2025-05-01", "2025-05-25");

    if (data != null && data['data'] != null) {
      int total = 0;
      for (var dayData in data['data']['data']) {
        for (var entry in dayData['data']) {
          total += int.tryParse(entry['value'].toString()) ?? 0;
        }
      }
      totalStepsMonth = total;
    } else {
      totalStepsMonth = 0;
    }

    notifyListeners();
  }

Future<void> fetchWeekNumSteps() async {
    final data = await ImpactRequest.fetchStepDataRange("2025-05-19", "2025-05-25");

    if (data != null && data['data'] != null) {
      int total = 0;
      for (var dayData in data['data']['data']) {
        for (var entry in dayData['data']) {
          total += int.tryParse(entry['value'].toString()) ?? 0;
        }
      }
      totalStepsWeek = total;
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
  
}//DataProvider