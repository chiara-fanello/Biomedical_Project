import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
<<<<<<< HEAD
import 'sleepPage.dart';
import 'restingHeartRatePage.dart';
=======
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

>>>>>>> e8901bb6eed54b7742b9532055650d95bdd7fef2

class HomePage extends StatelessWidget {
  HomePage({super.key});

final rand = Random();
int randRow = 0;

Future<List<List<dynamic>>> loadCsvData() async {
  final raw = await rootBundle.loadString('assets/DoYouKnow.csv');
  final data = const CsvToListConverter(fieldDelimiter: ';').convert(raw);
  return data.toList(); 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
        actions: [
          IconButton(
            icon: Icon(Icons.bed),
            tooltip: 'Sleep Data',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SleepPage(day: '2025-03-27'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.monitor_heart), // oppure Icons.favorite
            tooltip: 'Heart Rate',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestingHeartRatePage(day: '2025-03-20'),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Your today's progess",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRing(
                    context,
                    percent: 0.7,
                    color: Colors.deepPurple,
                    label: "Movement",
                  ),
                  _buildRing(
                    context,
                    percent: 0.5,
                    color: Colors.blueAccent,
                    label: "Workout",
                  ),
                  _buildRing(
                    context,
                    percent: 0.3,
                    color: Colors.green,
                    label: "Rest",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Today's goals:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.question_mark_rounded,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "DO YOU KNOW...??",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    FutureBuilder<List<List<dynamic>>>(
                      future: loadCsvData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Errore nel CSV');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('CSV vuoto');
                        }

                        final righe = snapshot.data!;
                        final randomIndex = Random().nextInt(righe.length);
                        final riga = righe[randomIndex];
                        final frase = riga[0];
                        final spiegazione = riga[1];

                        return Column(
                          children: [
                            Text(frase, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 8),
                            Text(spiegazione, style: TextStyle(fontSize: 14)),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRing(
    BuildContext context, {
    required double percent,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 8.0,
          percent: percent,
          center: Text(
            "${(percent * 100).toInt()}%",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          progressColor: color,
          backgroundColor: Colors.grey.shade300,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animateFromLastPercent: true,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
