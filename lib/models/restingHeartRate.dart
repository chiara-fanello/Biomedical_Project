class RestingHeartRate {
  final String date;
  final List<HeartRateEntry> data;

  RestingHeartRate({required this.date, required this.data});

  factory RestingHeartRate.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    final rawData = dataJson['data'];

    List<HeartRateEntry> entries;
    if (rawData is List) {
      entries = rawData.map((entry) => HeartRateEntry.fromJson(entry)).toList();
    } else if (rawData is Map<String, dynamic>) {
      entries = [HeartRateEntry.fromJson(rawData)];
    } else {
      entries = [];
    }

    return RestingHeartRate(date: dataJson['date'], data: entries);
  }
}

class HeartRateEntry {
  final String time;
  final double value;
  final double error;

  HeartRateEntry({
    required this.time,
    required this.value,
    required this.error,
  });

  factory HeartRateEntry.fromJson(Map<String, dynamic> json) {
    return HeartRateEntry(
      time: json['time'],
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      error: double.tryParse(json['error'].toString()) ?? 0.0,
    );
  }
}
