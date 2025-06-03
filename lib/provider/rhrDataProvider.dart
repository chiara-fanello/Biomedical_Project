import 'package:flutter/material.dart';
import '../models/restingHeartRate.dart';
import '../services/impact.dart';

class RestingHeartRateProvider extends ChangeNotifier {
  RestingHeartRate? restingHeartRate;

  // Fetches resting heart rate data for the given day
  Future<void> fetchRestingHeartRate(String day) async {
    final data = await ImpactRequest.fetchRestingHeartRateData(day);

    print('Data received for $day:\n$data'); // Debug

    if (data != null && data['status'] == 'success' && data['data'] != null) {
      try {
        restingHeartRate = RestingHeartRate.fromJson(data);
        notifyListeners();
        print('Resting heart rate data loaded successfully');
      } catch (e) {
        print('Error while parsing data: $e');
      }
    } else {
      print('Invalid response or missing data for $day');
    }
  }

  // Clears stored resting heart rate data
  void clearData() {
    restingHeartRate = null;
    notifyListeners();
  }
}
