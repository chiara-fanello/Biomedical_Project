import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/goalsProvider.dart';
import 'package:flutter_application_1/screens/goalsPage.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'sleepPage.dart';
import 'stepPage.dart';
import 'distancePage.dart';
import 'caloriesPage.dart';
import '../../provider/stepDataProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialized = false;

  Future<List<List<dynamic>>> loadCsvData() async {
    final raw = await rootBundle.loadString('assets/DoYouKnow.csv');
    final data = const CsvToListConverter(fieldDelimiter: ';').convert(raw);
    return data.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final stepProvider = Provider.of<StepDataProvider>(
        context,
        listen: false,
      );
      stepProvider.fetchDayNumSteps();
      _initialized = true;
    }
  }

  Widget _buildDataBox({
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int lessons = Provider.of<GoalsProvider>(context).lessons();
    return Scaffold(
      appBar: AppBar(title: Text('Welcome!')),

      body: SingleChildScrollView(
        // Aggiunto SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Today's Progress",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Consumer<StepDataProvider>(
              builder: (context, stepProvider, _) {
                return Column(
                  children: [
                    Row(
                      children: [
                        _buildDataBox(
                          label: 'Steps',
                          value:
                              stepProvider.totalStepsDay?.toString() ?? '...',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => StepPage()),
                            );
                          },
                        ),
                        _buildDataBox(
                          label: 'Sleep',
                          value: '...h',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SleepPage(day: '2025-03-27'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildDataBox(
                          label: 'Calories',
                          value: '...kcal',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CaloriesPage()),
                            );
                          },
                        ),
                        _buildDataBox(
                          label: 'Distance',
                          value: '...km',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DistancePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 131, 194, 141),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Goal of the day',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      Provider.of<GoalsProvider>(
                        context,
                        listen: false,
                      ).getGoalString(lessons + 1),
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(16),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Errore nel CSV');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('CSV vuoto');
                        }

                        final righe = snapshot.data!;
                        final randomIndex = Random().nextInt(righe.length);
                        final riga = righe[randomIndex];
                        final frase = riga[0];
                        final spiegazione = riga[1];

                        return Column(
                          children: [
                            Text(
                              frase,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
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
}
