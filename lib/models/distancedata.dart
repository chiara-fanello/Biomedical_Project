import 'package:intl/intl.dart';

class DistanceData{
  final DateTime time;
  final int value;

  DistanceData({required this.time, required this.value});

  DistanceData.fromJson(String date, Map<String, dynamic> json) :
      time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = int.parse(json["value"]);

  @override
  String toString() {
    return 'DistanceData(time: $time, value: $value)';
  }//toString

  
}//Distance