import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/caloriesDataProvider.dart';
import 'package:flutter_application_1/provider/goalsProvider.dart';
import 'package:flutter_application_1/screens/goalsPage.dart';
import 'package:intl/intl.dart';
import '../../provider/rhrDataProvider.dart';
import '../../provider/sleepDataProvider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'sleepPage.dart';
import 'stepPage.dart';
import 'distancePage.dart';
import 'caloriesPage.dart';
import '../../provider/stepDataProvider.dart';
import '../../provider/distanceDataProvider.dart';
import '../../provider/caloriesDataProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialized = false;
  final String day = '2025-05-14';

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadData();
      });
      _initialized = true;
    }
  }

  // Call to provider to fetch sleep data
  Future<void> _loadData() async {
    final referenceDay = DateTime.parse(day);
    final todayStr = DateFormat('yyyy-MM-dd').format(referenceDay);
    final startDateStr = DateFormat(
      'yyyy-MM-dd',
    ).format(referenceDay.subtract(const Duration(days: 6)));

    try {
      await Future.wait([
        Provider.of<SleepDataProvider>(
          context,
          listen: false,
        ).fetchSleepData(day),
        Provider.of<SleepDataProvider>(
          context,
          listen: false,
        ).fetchSleepDataRange(startDateStr, todayStr),
        Provider.of<RestingHeartRateProvider>(
          context,
          listen: false,
        ).fetchRestingHeartRate(day),
        Provider.of<DistanceDataProvider>(
          context, 
          listen: false
          ).fetchDayNumDistance(),
        Provider.of<CaloriesDataProvider>(context, listen: false).fetchDayNumCalories(),
      ]);
    } catch (e) {
      // Handle potential errors here (log, snackBar, etc.)
      print('Data loading error: $e');
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
    final sleepDuration =
        context.watch<SleepDataProvider>().getLastNightSleepDurationString() ??
        '...';

    int lessons = Provider.of<GoalsProvider>(context).lessons();
    return Scaffold(
      appBar: AppBar(title: Text('Welcome!')),

      body: SingleChildScrollView(
        // Added SingleChildScrollView
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

            Consumer3<
              StepDataProvider,
              DistanceDataProvider,
              CaloriesDataProvider
            >(
              builder: (
                context,
                stepProvider,
                distanceProvider,
                caloriesProvider,
                _,
              ) {
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
                          value: sleepDuration,
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SleepPage(day: day),
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
                          value:
                              caloriesProvider.totalCaloriesDay?.toString() ??
                              '... cal',
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
                          value:
                              distanceProvider.totalDistanceDay !=
                                      null // otherwise could use '??' as above
                                  ? '${distanceProvider.totalDistanceDay!.toStringAsFixed(2)} km' // to show only two decimals
                                  : '... km',
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

            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 131, 194, 141),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GoalsPage(id: lessons + 1)),
                      );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Goal of the day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8), 
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
            ),

            //const SizedBox(height: 5),
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
                          return Text('CSV error');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('Empty CSV');
                        }

                        final rows = snapshot.data!;
                        final randomIndex = Random().nextInt(rows.length);
                        final row = rows[randomIndex];
                        final phrase = row[0];
                        final explanation = row[1];

                        return Column(
                          children: [
                            Text(
                              phrase,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(explanation, style: TextStyle(fontSize: 14)),
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
