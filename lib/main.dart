import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/caloriesDataProvider.dart';
import 'package:flutter_application_1/provider/distanceDataProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_application_1/provider/goalsProvider.dart';
import 'provider/loginProvider.dart';
import 'provider/sleepDataProvider.dart';
import 'provider/stepDataProvider.dart';
import 'package:provider/provider.dart';
import 'screens/loginPage.dart';
import 'provider/rhrDataProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('it');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SleepDataProvider()),
        ChangeNotifierProvider(create: (_) => RestingHeartRateProvider()),
        ChangeNotifierProvider(create: (_) => StepDataProvider()),
        ChangeNotifierProvider(create: (_) => CaloriesDataProvider()),
        ChangeNotifierProvider(create: (_) => DistanceDataProvider()),
        ChangeNotifierProvider(create: (_) => GoalsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debuggers Anonimi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
