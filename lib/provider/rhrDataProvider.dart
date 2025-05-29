import 'package:flutter/material.dart';
import '../models/restingHeartRate.dart';
import '../services/impact.dart';

class RestingHeartRateProvider extends ChangeNotifier {
  RestingHeartRate? restingHeartRate;

  Future<void> fetchRestingHeartRate(String day) async {
    final data = await ImpactRequest.fetchRestingHeartRateData(day);

    print('Dati ricevuti per $day:\n$data'); // Debug

    if (data != null && data['status'] == 'success' && data['data'] != null) {
      try {
        restingHeartRate = RestingHeartRate.fromJson(data);
        notifyListeners();
        print('Dati resting heart rate caricati correttamente');
      } catch (e) {
        print('Errore nel parsing dei dati: $e');
      }
    } else {
      print('Risposta non valida o dati mancanti per il giorno $day');
    }
  }

  // Metodo per svuotare i dati
  void clearData() {
    restingHeartRate = null;
    notifyListeners();
  }
}
