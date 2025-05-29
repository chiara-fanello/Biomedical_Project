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
    print('Dati ricevuti per il giorno $day:\n$data');

    if (data != null && data['status'] == 'success' && data['data'] != null) {
      final dateStr = data['data']['date'];
      final year = dateStr.substring(0, 4);
      final inner = data['data']['data'];

      if (inner == null) {
        print('Nessun dato di sonno presente per il giorno $day');
        return;
      }

      try {
        sleepData.clear(); // Solo i dati giornalieri
        final sleep = SleepData.fromJson(inner, year);
        sleepData.add(sleep);

        // Aggiungi al grafico settimanale
        _updateWeeklySummary(sleep);

        notifyListeners();
        print('Dati del sonno caricati correttamente');
      } catch (e) {
        print('Errore nel parsing SleepData: $e');
      }
    } else {
      print('Risposta non valida o incompleta');
    }
  }

  void _updateWeeklySummary(SleepData data) {
    final segments = data.levelsData;
    if (segments.isEmpty) return;

    final duration = segments.last.end.difference(segments.first.start);
    final label = DateFormat(
      'EEE dd/MM',
    ).format(data.dateOfSleep); // giorno unico

    final summary = SleepSummary(label: label, duration: duration);

    // Evita duplicati precisi
    weeklySummaries.removeWhere((s) => s.label == label);
    weeklySummaries.add(summary);

    // Mantieni massimo 7 elementi (i più recenti)
    if (weeklySummaries.length > 7) {
      weeklySummaries.removeAt(0);
    }

    // (facoltativo) Ordina per label/data
    weeklySummaries.sort((a, b) => a.label.compareTo(b.label));
  }

  void clearData() {
    print('Clear solo sleepData, NON weeklySummaries');
    sleepData.clear();
    notifyListeners();
  }

  List<SleepSummary> getWeeklySummaries() => weeklySummaries;
}
