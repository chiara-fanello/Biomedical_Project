import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoalsPage extends StatelessWidget {
  final int id;
  final bool completed;
  const GoalsPage({Key? key, required this.id, required this.completed}) : super(key: key);

  Future<List<List<dynamic>>> loadCsvData() async {
    final raw = await rootBundle.loadString('assets/Goals.csv');
    final data = const CsvToListConverter(fieldDelimiter: ';').convert(raw);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>>(
      future: loadCsvData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore nel caricamento del CSV'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('CSV vuoto o non trovato'));
        }

        final righe = snapshot.data!;
        final index = id;
        if (index < 0 || index >= righe.length) {
          return Center(child: Text('ID non valido'));
        }

        final riga = righe[index];

        final titolo = riga[0].toString();

        return Scaffold(
          appBar: AppBar(title: Text('Goals$id')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titolo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // da mettere box progressione / mission completed
                const SizedBox(height: 16),
                Text(
                  completed.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
