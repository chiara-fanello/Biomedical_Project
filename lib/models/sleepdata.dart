import 'package:intl/intl.dart';

class SleepData {
  final DateTime dateOfSleep;
  final SleepLevelsSummary levelsSummary;
  final List<SleepSegment> levelsData;

  SleepData({
    required this.dateOfSleep,
    required this.levelsSummary,
    required this.levelsData,
  });

  factory SleepData.fromJson(Map<String, dynamic> json, String baseDate) {
    List<SleepSegment> levelsData = [];

    // Parse sleep level segments if available
    if (json['levels'] != null && json['levels']['data'] != null) {
      levelsData =
          (json['levels']['data'] as List)
              .map((e) => SleepSegment.fromJson(e))
              .toList();
    }

    // Parse the date (format: MM-dd) and assume current year
    final dateFormat = DateFormat('MM-dd');
    final parsedDate = dateFormat.parse(json['dateOfSleep']);
    final fullDate = DateTime(
      DateTime.now().year,
      parsedDate.month,
      parsedDate.day,
    );

    return SleepData(
      dateOfSleep: fullDate,
      levelsSummary: SleepLevelsSummary.fromJson(json['levels']['summary']),
      levelsData: levelsData,
    );
  }
}

class SleepLevelsSummary {
  final SleepStageSummary deep;
  final SleepStageSummary light;
  final SleepStageSummary rem;
  final SleepStageSummary wake;

  SleepLevelsSummary({
    required this.deep,
    required this.light,
    required this.rem,
    required this.wake,
  });

  factory SleepLevelsSummary.fromJson(Map<String, dynamic> json) {
    return SleepLevelsSummary(
      deep: SleepStageSummary.fromJson(json['deep']),
      light: SleepStageSummary.fromJson(json['light']),
      rem: SleepStageSummary.fromJson(json['rem']),
      wake: SleepStageSummary.fromJson(json['wake']),
    );
  }
}

class SleepStageSummary {
  final int minutes;

  SleepStageSummary({required this.minutes});

  factory SleepStageSummary.fromJson(Map<String, dynamic> json) {
    return SleepStageSummary(minutes: json['minutes']);
  }
}

enum SleepStage { light, deep, rem, awake }

class SleepSegment {
  final SleepStage stage;
  final DateTime start;
  final DateTime end;

  SleepSegment({required this.stage, required this.start, required this.end});

  factory SleepSegment.fromJson(Map<String, dynamic> json) {
    final String level = (json['level'] as String).toLowerCase();

    // Map JSON level string to SleepStage enum
    final SleepStage mappedStage = switch (level) {
      'light' => SleepStage.light,
      'deep' => SleepStage.deep,
      'rem' => SleepStage.rem,
      'wake' => SleepStage.awake,
      _ => SleepStage.light, // Safe fallback
    };

    final format = DateFormat(
      'MM-dd HH:mm:ss',
    ); // Make sure this matches your data format

    late DateTime start;
    late DateTime end;

    try {
      // Handle both possible data structures
      if (json.containsKey('start') && json.containsKey('end')) {
        start = format.parse(json['start']);
        end = format.parse(json['end']);
      } else if (json.containsKey('dateTime') && json.containsKey('seconds')) {
        start = format.parse(json['dateTime']);
        end = start.add(Duration(seconds: json['seconds']));
      } else {
        throw FormatException('Missing keys in JSON');
      }

      if (end.isBefore(start)) {
        throw FormatException('End time is before start time');
      }

      return SleepSegment(stage: mappedStage, start: start, end: end);
    } catch (e) {
      // Print detailed error for debugging
      print('Error parsing SleepSegment: $e\nData: $json');
      throw FormatException('Error parsing SleepSegment: $e - $json');
    }
  }

  Duration get duration => end.difference(start);

  @override
  String toString() {
    return 'SleepSegment(stage: $stage, start: $start, end: $end, duration: ${duration.inMinutes} min)';
  }
}

class WeeklySleepSummary {
  final DateTime date;
  final Duration totalSleep;

  WeeklySleepSummary({required this.date, required this.totalSleep});
}

List<WeeklySleepSummary> parseWeeklySleepData(Map<String, dynamic> json) {
  final List<WeeklySleepSummary> summaries = [];

  if (json['status'] == 'success' && json['data'] != null) {
    for (var item in json['data']) {
      final dateStr = item['date'] as String;
      final sleepData = item['data'];
      final durationMs = (sleepData['duration'] as num).toInt();

      final date = DateTime.parse(dateStr);
      final totalSleep = Duration(milliseconds: durationMs);

      summaries.add(WeeklySleepSummary(date: date, totalSleep: totalSleep));
    }
  }

  return summaries;
}
